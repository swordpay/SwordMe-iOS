//
//  ChatMessageTransactionBubbleContentNode.swift
//  TelegramUI
//
//  Created by Tigran Simonyan on 18.09.23.
//

import Foundation
import UIKit
import AsyncDisplayKit
import Display
import SwiftSignalKit
import Postbox
import TelegramCore
import TelegramUIPreferences
import TelegramPresentationData
import AccountContext
import GridMessageSelectionNode
import ChatControllerInteraction
import SwordAppArch
import Combine

class ChatMessageTransactionBubbleContentNode: ChatMessageTransactionBaseBubbleContentNode<ChatPaymentItemView, ChatPaymentItemViewModel> {
    override func provideChatItemMessaage(item: ChatMessageBubbleContentItem) -> ChatPaymentItemViewModel? {
        guard let decodedMessage = DecodedPaymentMessage(text: item.message.text), let author = item.message.author else { return nil }
        
        return .init(decodedMessage: decodedMessage,
                     isMine: AppData.userTelegramPeerId == author.id.id._internalGetInt64Value(),
                     author: author,
                     messageId: item.message.id.id,
                     context: item.context,
                     theme: item.presentationData.theme.theme)
    }
}

class ChatMessageTransactionBaseBubbleContentNode<ContentView: SetupableView, ContentViewModel: ChatMessageTransactionContentViewModelling>: ChatMessageBubbleContentNode where ContentView.SetupModel == ContentViewModel {
    override var supportsMosaic: Bool {
        return false
    }
    
    private var selectionNode: GridMessageSelectionNode?
    private var highlightedState: Bool = false

    private var chatPaymentView: ContentView?
    
    private let statusNode: ChatMessageDateAndStatusNode
    
    required init() {
        self.statusNode = ChatMessageDateAndStatusNode()

        super.init()

        self.statusNode.reactionSelected = { [weak self] value in
            guard let strongSelf = self, let item = strongSelf.item else {
                return
            }
            item.controllerInteraction.updateMessageReaction(item.message, .reaction(value))
        }
        
        self.statusNode.openReactionPreview = { [weak self] gesture, sourceNode, value in
            guard let strongSelf = self, let item = strongSelf.item else {
                gesture?.cancel()
                return
            }
            
            item.controllerInteraction.openMessageReactionContextMenu(item.topMessage, sourceNode, gesture, value)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChatPaymentView() {
        guard chatPaymentView == nil else { return }
        
        let chatPaymentItemView = ContentView.loadFromNib()!
        chatPaymentItemView.frame = view.bounds
        chatPaymentItemView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(chatPaymentItemView)
        chatPaymentItemView.addBorderConstraints(constraintSides: .all)
        self.view.bringSubviewToFront(self.statusNode.view)
        
        self.layoutIfNeeded()
        self.chatPaymentView = chatPaymentItemView
    }
    
    override func asyncLayoutContent() -> (_ item: ChatMessageBubbleContentItem, _ layoutConstants: ChatMessageItemLayoutConstants, _ preparePosition: ChatMessageBubblePreparePosition, _ messageSelection: Bool?, _ constrainedSize: CGSize, _ avatarInset: CGFloat) -> (ChatMessageBubbleContentProperties, CGSize?, CGFloat, (CGSize, ChatMessageBubbleContentPosition) -> (CGFloat, (CGFloat) -> (CGSize, (ListViewItemUpdateAnimation, Bool, ListViewItemApply?) -> Void))) {
        
        DispatchQueue.main.async {
            self.setupChatPaymentView()
        }
        
        let statusLayout = self.statusNode.asyncLayout()
        
        return { [ weak self ] item, layoutConstants, _, _, _, _ in
            let contentProperties = ChatMessageBubbleContentProperties(hidesSimpleAuthorHeader: false, headerSpacing: 0.0, hidesBackground: .never, forceFullCorners: false, forceAlignment: .none)
            
            let chatPaymentViewModel = self?.provideChatItemMessaage(item: item)
            if let chatPaymentViewModel {
                DispatchQueue.main.async {
                    self?.chatPaymentView?.setup(with: chatPaymentViewModel)
                }
            }
            
            return (contentProperties, nil, CGFloat.greatestFiniteMagnitude, { [ weak self, chatPaymentViewModel ] constrainedSize, position in
                let message = item.message
                
                let incoming: Bool
                if let subject = item.associatedData.subject, case .forwardedMessages = subject {
                    incoming = false
                } else {
                    incoming = item.message.effectivelyIncoming(item.context.account.peerId)
                }
                
                var maxTextWidth = CGFloat.greatestFiniteMagnitude
                for media in item.message.media {
                    if let webpage = media as? TelegramMediaWebpage, case let .Loaded(content) = webpage.content, content.type == "telegram_background" || content.type == "telegram_theme" {
                        maxTextWidth = layoutConstants.wallpapers.maxTextWidth
                        break
                    }
                }
                
                let horizontalInset = layoutConstants.text.bubbleInsets.left + layoutConstants.text.bubbleInsets.right
                let textConstrainedSize = CGSize(width: min(maxTextWidth, constrainedSize.width - horizontalInset), height: constrainedSize.height)
                
                var edited = false
                if item.attributes.updatingMedia != nil {
                    edited = true
                }
                var viewCount: Int?
                var dateReplies = 0
                var dateReactionsAndPeers = mergedMessageReactionsAndPeers(accountPeer: item.associatedData.accountPeer, message: item.topMessage)
                if item.message.isRestricted(platform: "ios", contentSettings: item.context.currentContentSettings.with { $0 }) {
                    dateReactionsAndPeers = ([], [])
                }
                
                for attribute in item.message.attributes {
                    if let attribute = attribute as? EditedMessageAttribute {
                        edited = !attribute.isHidden
                    } else if let attribute = attribute as? ViewCountMessageAttribute {
                        viewCount = attribute.count
                    } else if let attribute = attribute as? ReplyThreadMessageAttribute, case .peer = item.chatLocation {
                        if let channel = item.message.peers[item.message.id.peerId] as? TelegramChannel, case .group = channel.info {
                            dateReplies = Int(attribute.count)
                        }
                    }
                }
                
                let dateFormat: MessageTimestampStatusFormat
                if let subject = item.associatedData.subject, case .forwardedMessages = subject {
                    dateFormat = .minimal
                } else {
                    dateFormat = .regular
                }
                let dateText = stringForMessageTimestampStatus(accountPeerId: item.context.account.peerId, message: item.message, dateTimeFormat: item.presentationData.dateTimeFormat, nameDisplayOrder: item.presentationData.nameDisplayOrder, strings: item.presentationData.strings, format: dateFormat, associatedData: item.associatedData)
                
                let statusType: ChatMessageDateAndStatusType?
                var displayStatus = false
                switch position {
                case let .linear(_, neighbor):
                    if case .None = neighbor {
                        displayStatus = true
                    } else if case .Neighbour(true, _, _) = neighbor {
                        displayStatus = true
                    }
                default:
                    break
                }
                if displayStatus {
                    if incoming {
                        statusType = .BubbleIncoming
                    } else {
                        if message.flags.contains(.Failed) {
                            statusType = .BubbleOutgoing(.Failed)
                        } else if (message.flags.isSending && !message.isSentOrAcknowledged) || item.attributes.updatingMedia != nil {
                            statusType = .BubbleOutgoing(.Sending)
                        } else {
                            statusType = .BubbleOutgoing(.Sent(read: item.read))
                        }
                    }
                } else {
                    statusType = nil
                }
                                                
                var statusSuggestedWidthAndContinue: (CGFloat, (CGFloat) -> (CGSize, (ListViewItemUpdateAnimation) -> Void))?
                if let statusType = statusType {
                    var isReplyThread = false
                    if case .replyThread = item.chatLocation {
                        isReplyThread = true
                    }
                    
                    let trailingWidthToMeasure: CGFloat = 0
                    
                    let dateLayoutInput: ChatMessageDateAndStatusNode.LayoutInput
                    dateLayoutInput = .trailingContent(contentWidth: trailingWidthToMeasure, reactionSettings: ChatMessageDateAndStatusNode.TrailingReactionSettings(displayInline: shouldDisplayInlineDateReactions(message: item.message, isPremium: item.associatedData.isPremium, forceInline: item.associatedData.forceInlineReactions), preferAdditionalInset: false))
                    
                    statusSuggestedWidthAndContinue = statusLayout(ChatMessageDateAndStatusNode.Arguments(
                        context: item.context,
                        presentationData: item.presentationData,
                        edited: edited,
                        impressionCount: viewCount,
                        dateText: dateText,
                        type: statusType,
                        layoutInput: dateLayoutInput,
                        constrainedSize: textConstrainedSize,
                        availableReactions: item.associatedData.availableReactions,
                        reactions: dateReactionsAndPeers.reactions,
                        reactionPeers: dateReactionsAndPeers.peers,
                        displayAllReactionPeers: item.message.id.peerId.namespace == Namespaces.Peer.CloudUser,
                        replyCount: dateReplies,
                        isPinned: item.message.tags.contains(.pinned) && (!item.associatedData.isInPinnedListMode || isReplyThread),
                        hasAutoremove: item.message.isSelfExpiring,
                        canViewReactionList: canViewMessageReactionList(message: item.message),
                        animationCache: item.controllerInteraction.presentationContext.animationCache,
                        animationRenderer: item.controllerInteraction.presentationContext.animationRenderer
                    ))
                    
                }
                

                let textInsets: UIEdgeInsets = .zero
                var textFrame = CGRect(origin: CGPoint(x: -5, y: -5), size: .init(width: Constants.paymentItemWidth,
                                                                                                             height: chatPaymentViewModel?.frameHeight ?? 120))
                var textFrameWithoutInsets = CGRect(origin: CGPoint(x: textFrame.origin.x + textInsets.left, y: textFrame.origin.y + textInsets.top), size: CGSize(width: textFrame.width - textInsets.left - textInsets.right, height: textFrame.height - textInsets.top - textInsets.bottom))
                
                textFrame = textFrame.offsetBy(dx: layoutConstants.text.bubbleInsets.left, dy: layoutConstants.text.bubbleInsets.top)
                textFrameWithoutInsets = textFrameWithoutInsets.offsetBy(dx: layoutConstants.text.bubbleInsets.left, dy: layoutConstants.text.bubbleInsets.top)

                var suggestedBoundingWidth: CGFloat = textFrameWithoutInsets.width
                if let statusSuggestedWidthAndContinue = statusSuggestedWidthAndContinue {
                    suggestedBoundingWidth = max(suggestedBoundingWidth, statusSuggestedWidthAndContinue.0)
                }
                let sideInsets = layoutConstants.text.bubbleInsets.left + layoutConstants.text.bubbleInsets.right
                suggestedBoundingWidth += sideInsets
                
                return (suggestedBoundingWidth, { boundingWidth in
                    var boundingSize: CGSize
                    
                    let statusSizeAndApply = statusSuggestedWidthAndContinue?.1(boundingWidth - sideInsets)
                    
                    boundingSize = textFrameWithoutInsets.size
                    if let statusSizeAndApply = statusSizeAndApply {
                        boundingSize.height += statusSizeAndApply.0.height
                    }
                    
                    boundingSize.width += layoutConstants.text.bubbleInsets.left + layoutConstants.text.bubbleInsets.right
                    boundingSize.height += layoutConstants.text.bubbleInsets.top + layoutConstants.text.bubbleInsets.bottom
                    
                    return (boundingSize, { [weak self] animation, synchronousLoads, _ in
                        if let strongSelf = self {
                            strongSelf.item = item
                            
                            if let statusSizeAndApply = statusSizeAndApply {
                                animation.animator.updateFrame(layer: strongSelf.statusNode.layer, frame: CGRect(origin: CGPoint(x: textFrameWithoutInsets.minX, y: textFrameWithoutInsets.maxY), size: statusSizeAndApply.0), completion: nil)
                                if strongSelf.statusNode.supernode == nil {
                                    strongSelf.addSubnode(strongSelf.statusNode)
                                    statusSizeAndApply.1(.None)
                                } else {
                                    statusSizeAndApply.1(animation)
                                }
                            } else if strongSelf.statusNode.supernode != nil {
                                strongSelf.statusNode.removeFromSupernode()
                            }
                            
                            if let forwardInfo = item.message.forwardInfo, forwardInfo.flags.contains(.isImported) {
                                strongSelf.statusNode.pressed = {
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    item.controllerInteraction.displayImportedMessageTooltip(strongSelf.statusNode)
                                }
                            } else {
                                strongSelf.statusNode.pressed = nil
                            }
                        }
                    })
                })
            })
        }
    }

    override func tapActionAtPoint(_ point: CGPoint, gesture: TapLongTapOrDoubleTapGesture, isEstimating: Bool) -> ChatMessageBubbleContentTapAction {
        if self.statusNode.supernode != nil,
           let _ = self.statusNode.hitTest(self.view.convert(point, to: self.statusNode.view), with: nil) {
            return .ignore
        }
        return .none
    }
    
    override func animateInsertion(_ currentTimestamp: Double, duration: Double) {
        self.layer.animateAlpha(from: 0.0, to: 1.0, duration: 0.25)
    }
    
    override func animateAdded(_ currentTimestamp: Double, duration: Double) {
        self.layer.animateAlpha(from: 0.0, to: 1.0, duration: 0.25)
    }
    
    override func animateRemoved(_ currentTimestamp: Double, duration: Double) {
        self.layer.animateAlpha(from: 1.0, to: 0.0, duration: 0.25, removeOnCompletion: false)
    }
    
    override func animateInsertionIntoBubble(_ duration: Double) {
        self.layer.animateAlpha(from: 0.0, to: 1.0, duration: 0.25)
    }
    
    override func reactionTargetView(value: MessageReaction.Reaction) -> UIView? {
        if !self.statusNode.isHidden {
            return self.statusNode.reactionView(value: value)
        }
        return nil
    }
    
    override func getStatusNode() -> ASDisplayNode? {
        return self.statusNode
    }
    
    public func provideChatItemMessaage(item: ChatMessageBubbleContentItem) -> ContentViewModel? {
        fatalError("Should be implemented by children")
    }
}
