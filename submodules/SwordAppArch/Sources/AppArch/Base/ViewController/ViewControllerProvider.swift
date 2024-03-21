//
//  ViewControllerProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.06.22.
//

import UIKit
import Combine
import Swinject
import CoreLocation

public enum ViewControllerProvider {}

extension ViewControllerProvider {
    public enum Common {
        static func completions(stackModel: CompletionStackViewModel, dismissAction: Constants.Typealias.VoidHandler? = nil) -> CompletionViewController {
            let assembler = Assembler([CompletionViewControllerAssembly(stackModel: stackModel,
                                                                        dismissAction: dismissAction)])

            return assembler.resolver.resolve(CompletionViewController.self)!
        }

        static func map(for location: CLLocation, title: String? = nil) -> MapViewController {
            let assembler = Assembler([MapStackViewControllerAssembly(location: location, title: title)])

            return assembler.resolver.resolve(MapViewController.self)!
        }
        
        static func pickerController(with sourceType: UIImagePickerController.SourceType,
                                     mediaSelectionHandler: @escaping Constants.Typealias.CompletioHandler<MediaType>) -> MediaPickerViewController {
            let assembler = Assembler([MediaPickerViewControllerAssembly(sourceType: sourceType,
                                                                         mediaSelectionHandler: mediaSelectionHandler)])

            return assembler.resolver.resolve(MediaPickerViewController.self)!
        }
                        
        static func qrCodePager(scanResultPublisher: PassthroughSubject<String?, Never>) -> QRCodePagerViewController {
            let assembler = Assembler([QRCodePagerViewControllerAssembly(scanResultPublisher: scanResultPublisher)])
            let controller = assembler.resolver.resolve(QRCodePagerViewController.self)!

            return controller
        }

        static func qrScanner(hasCloseButton: Bool,
                              resultPublisher: PassthroughSubject<String?, Never>) ->  QRScannerViewController {
            let assembler = Assembler([ QRScannerViewControllerAssembly(hasCloseButton: hasCloseButton,
                                                                        resultPublisher: resultPublisher)])

            return assembler.resolver.resolve(QRScannerViewController.self)!
        }
        
        public static func myQRCode(username: String? = nil) -> MyQRCodeViewController {
            let assembler = Assembler([DataCacherAssembly(),
                                       URLSessionDataDownloaderAssembly(),
                                       DataDownloadManagerAssembly(),
                                       MyQRCodeViewControllerAssembly(username: username)])
            let controller = assembler.resolver.resolve(MyQRCodeViewController.self)!

            return controller
        }
        
        static var bottomSheet: BottomSheetViewController {
            let assembler = Assembler([BottomSheetViewControllerAssembly()])
            let controller = assembler.resolver.resolve(BottomSheetViewController.self)!

            return controller
        }
    }
}
