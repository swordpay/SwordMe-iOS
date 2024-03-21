//
//  QRScannerStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.02.23.
//

import UIKit
import AVFoundation

final class QRScannerStackView: SetupableStackView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var previewHolderView: UIView!
    @IBOutlet private weak var availableAreaHelperView: UIView!
    @IBOutlet private weak var scannerBorderImageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton!

    // MARK: - Properties
    
    private var model: QRScannerStackViewModel?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let captureSession = AVCaptureSession()

    // MARK: - Lifecycle Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let model else { return }
        closeButton.setCornerRadius(closeButton.frame.height / 2)
        closeButton.isHidden = !model.hasCloseButton
        previewLayer?.frame = previewHolderView.bounds
        createOverlay(model: model)
        bringSubviewToFront(closeButton)
    }

    // MARK: - Setup UI

    func setup(with model: QRScannerStackViewModel) {
        self.model = model
        
        setupVideoCapturingSession(model: model)
        startSession()
        
        availableAreaHelperView.layer.borderColor = theme.colors.mainWhite.cgColor
        availableAreaHelperView.layer.borderWidth = 1

        bringSubviewToFront(scannerBorderImageView)
        bringSubviewToFront(availableAreaHelperView)
    }
    
    func startSession() {
        DispatchQueue.global().async { [ weak self ] in
            self?.captureSession.startRunning()
        }
    }
    
    private func setupVideoCapturingSession(model: QRScannerStackViewModel) {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            model.resultPublisher.send(nil)

            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            model.resultPublisher.send(nil)
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        
        if let previewLayer {
            layer.addSublayer(previewLayer)
        }
    }
    
    func createOverlay(model: QRScannerStackViewModel) {
        let overlayFrame = model.prepareOverlayFrame(from: previewHolderView.bounds,
                                                     center: previewHolderView.center)
        let path = UIBezierPath(rect: bounds)
        let rectPath = UIBezierPath(rect: overlayFrame)

        path.append(rectPath)
        path.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = theme.colors.lightGray.withAlphaComponent(0.7).cgColor
        fillLayer.opacity = 0.7
        layer.addSublayer(fillLayer)
    }
    
    func stopSession() {
        captureSession.stopRunning()
    }
    
    // MARK: - Actions
    
    @IBAction private func closeButtonTouchUp(_ sender: UIButton) {
        guard let model else { return }
        stopSession()
        model.closeButtonActionPublisher.send(())
    }
}

extension QRScannerStackView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if let metadataObject = metadataObjects.first,
           let model {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            stopSession()
            model.resultPublisher.send(stringValue)
        }
    }
}
