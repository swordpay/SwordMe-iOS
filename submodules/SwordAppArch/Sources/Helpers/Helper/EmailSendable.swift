//
//  EmailSendable.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.07.22.
//

import UIKit
import Display
import MessageUI

protocol EmailSendable: NSObject  {
    func sendEmail(to recipient: String?, subject: String?, body: String?, attachment: Data?)
}

extension EmailSendable where Self: UIViewController & MFMailComposeViewControllerDelegate & Navigatable  {
    func sendEmail(to recipient: String?, subject: String?, body: String?, attachment: Data?) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            var recipients = [String]()
            
            if let recipient {
                recipients.append(recipient)
            }
            
            mail.mailComposeDelegate = self
            mail.setToRecipients(recipients)
            mail.setSubject(subject ?? "")
            mail.setMessageBody(body ?? "", isHTML: false)
            
            if let attachment {
                mail.addAttachmentData(attachment, mimeType: "image/png", fileName: "imageName.png")
            }
            
            if !(navigationController is NavigationController) {
                navigationController?.present(mail, animated: true)
            } else {
                present(mail, animated: true)
            }
        
        } else if let emailUrl = createEmailUrl(to: recipient, subject: subject, body: body),
                  UIApplication.shared.canOpenURL(emailUrl) {
            UIApplication.shared.open(emailUrl)
        } else {
            showFailAlert()
        }
    }
    
    private func createEmailUrl(to recipient: String?, subject: String?, body: String?) -> URL? {
        let recipientEncoded = (recipient ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let subjectEncoded = (subject ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = (body ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        lazy var gmailUrl = URL(string: "googlegmail://co?to=\(recipientEncoded)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        lazy var outlookUrl = URL(string: "ms-outlook://compose?to=\(recipientEncoded)&subject=\(subjectEncoded)")
        lazy var yahooMail = URL(string: "ymail://mail/compose?to=\(recipientEncoded)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        lazy var sparkUrl = URL(string: "readdle-spark://compose?recipient=\(recipientEncoded)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        lazy var defaultUrl = URL(string: "mailto:\(recipientEncoded)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        } else if let defaultUrl = defaultUrl, UIApplication.shared.canOpenURL(defaultUrl) {
            return defaultUrl
        }
        
        return nil
    }
    
    private func showFailAlert() {
        let alertModel = AlertModel(title: Constants.Localization.Common.information,
                                    message: Constants.Localization.Common.unableToHandleAction,
                                    preferredStyle: .alert,
                                    actions: [.ok],
                                    animated: true)
        let destination = AlertDestination.alert(model: alertModel, presentationCompletion: nil, actionCompletion: nil)

        navigator.goTo(destination)
    }
}
