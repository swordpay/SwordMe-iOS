//
//  HomeViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import Combine
import Foundation
import SwordAppArch

public struct HomeViewModelInputs {
    let getUserService: GetUserServicing
    let getUserByUsernameService: GetUserByUsernameServicing
    let verifyEmailTokenService: VerifyEmailTokenServicing
}

public final class HomeViewModel: BaseViewModel<HomeViewModelInputs>, StackViewModeling {
//    private var handler: DeeplinkBaseHandling?

    public var setupModel: CurrentValueSubject<HomeStackViewModel?, Never> = .init(.init())
    
    let actionsButtomViewModel = ChannelsActionsBottomViewModel()
    let headerModel = HomeHeaderViewModel(recentsSetupModel: .init(recentChannels: []))

    let scanResultPublisher: PassthroughSubject<String?, Never> = PassthroughSubject()

    override init(inputs: HomeViewModelInputs) {
        super.init(inputs: inputs)
        
        bindToSelectedTabIndex()
        bindToScanResultPublisher()
        bindToInternetConnectionQuality()
    }
    
    func payOrReqeustStateInfo(from user: ChannelUserModel) -> PayOrRequestStateInfoModel {
        return .init(peerId: nil,
                     source: .createPayment,
                     isRequesting: true,
                     channelInfo: nil,
                     requestInfo: nil)
    }

    func getUserInfo() {
        let route = GetUserParams()
        
        inputs.getUserService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                if case let .failure(error) = completion {
                    self?.logout()
                    print("error \(error.localizedDescription)")
                }
            } receiveValue: { response in
                AppData.currentUserInfo = response.user
            }.store(in: &cancellables)
    }

    func fetchUser(by username: String, completion: @escaping (ChannelUserModel?) -> Void) {
        let route = GetUserByUsernameParams(username: username)
        
        isLoading.send(true)
        
        inputs.getUserByUsernameService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] result in
                if case let .failure(error) = result {
                    self?.isLoading.send(false)
                    self?.error.send(error)
                    completion(nil)
                }
            } receiveValue: { [ weak self ] response in
                self?.isLoading.send(false)
                completion(response.user)
            }
            .store(in: &cancellables)
    }
    
    func verifyEmailToken(_ token: String, completion: @escaping (Bool) -> Void) {
        let route = VerifyEmailTokenParams(token: token)

        isLoading.send(true)

        inputs.verifyEmailTokenService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] result in
                self?.isLoading.send(false)

                if case let .failure(error) = result {
                    self?.error.send(error)
                    completion(false)
                }
            } receiveValue: { response in
                completion(response.data.success)
            }
            .store(in: &cancellables)
    }

    // MARK: - Binding

    private func bindToSelectedTabIndex() {
        headerModel.selectedTabIndex
            .sink { [ weak self ] index in
                self?.setupModel.value?.selectedIndex.send(index)
            }
            .store(in: &cancellables)
    }
    
    private func bindToScanResultPublisher() {
        scanResultPublisher
            .sink { [ weak self ] result in
                guard let self, let result else { return }

                self.handleQRScannedData(result: result)
            }
            .store(in: &cancellables)
    }
    
    private func handleQRScannedData(result: String) {
//        guard let url = URL(string: result) else { return }
//
//        DynamicLinks.dynamicLinks()
//            .handleUniversalLink(url) { [ weak self ] dynamicLink, error in
//                guard let self,
//                      let shortURL = dynamicLink?.url,
//                      let components = NSURLComponents(url: shortURL, resolvingAgainstBaseURL: true),
//                      let path = components.path,
//                      let key = DeeplinkDestinationKeys(rawValue: self.prepareDeeplinkPath(path)) else {
//
//
//                    return
//                }
//
//                self.handler = DeeplinkHandlerProvider.handler(for: key)
//                self.handler?.handle(url: shortURL)
//            }
    }
    
    private func bindToInternetConnectionQuality() {
//        SocketIOSocketManager.global.status
//            .sink { [ weak self ] status in
//                guard status != .error && status != .updating else { return }
//
//                switch status {
//                case .connecting:
//                    self?.headerModel.isInternetQualtyLow.send(true)
//                default:
//                    self?.headerModel.isInternetQualtyLow.send(false)
//                }
//            }
//            .store(in: &cancellables)
    }
    
    private func prepareDeeplinkPath(_ path: String) -> String {
//        guard path.contains("@") else { return path }
//
//        return DeeplinkDestinationKeys.payOrRequest.rawValue
        
        return ""
    }
}
