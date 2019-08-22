//
//  QRScannerViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/18/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import AVFoundation
import UIKit


class QRScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - PROPERTIES
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // struct that will store incoming data
    var receivedInformation : EncodedMedia.Media?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    // MARK: - HANDLERS
    
    @objc func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func found(code: String) {
        // no data was supplied
        if (code == "") {
            print("json conversion failed, please check the data pipeline")
            return
        }
        
        // decodes the information to be shared and stores it in a struct
        receivedInformation = EncodedMedia.JSONtoStruct(source: code)!
        
        // set the current view controller as root to conform to view hierarchy
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "QRScanner")
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
        
        // transitions to the receiving interface
        performSegue(withIdentifier: "toMediaReceived", sender: self)
    }
    
    // sets the recieved property to the data read
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMediaReceived") {
            let recievedVC = segue.destination as! Received
            recievedVC.receivedInfo = self.receivedInformation!
        }
    }
    
    // MARK: - CUSTOMIZATION
    
    func configureNavigationBar() {
        
        // makes the navigation bar transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // add a back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "streamline-icon-navigation-left-2@24x24").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackButton))
    }
    
    // doesn't show battery and cellular status
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
