//
//  ScanBarcode.swift
//  Allergy Without StoryBoard
//
//  Created by Owen Hu on 3/5/23.
//

import UIKit
import Vision
import AVFoundation

class BarcodeScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    // declaration of capture Session
    var captureSession : AVCaptureSession!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    // setup camera session
    
    public func setup() {
        view.backgroundColor = UIColor.systemBlue
        // object or instance of AVCaptureSession
        captureSession = AVCaptureSession()
        print("working")
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        let videoInput : AVCaptureDeviceInput
        
        do {
            
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch{
            print(error.localizedDescription)
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }else{
            // add another method to alert program to stop ..... laters
            capture_failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
            // EAN-8, EAN-13 are symbology
            // Encryption and Decryption process (Encode and Decode) enigma
        }else{
            // add another method to alert program to stop ... laters
            capture_failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
//        image_display = previewLayer
        // simply use barcode reader instead of the image picker controller
        // allow the barcode reader to read the photo. (it requires two different module work together such as UIImagepicker Controller and AVCaptureSession.
        //
        captureSession.startRunning()
        
        print("working")
    }
    
    func capture_failed() {
        let alert = UIAlertController(title: "Not Available...", message: "Check The Device", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
            captureSession.stopRunning();
        }
    }
    
    // protocol method
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else {return}
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            // method to be called later
            found_string_display(code: stringValue)
        }
        
        self.dismiss(animated: true)
    }
    
    public func found_string_display(code : String) {
        print(code)
        // pass the data to the textview or label or textfield
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }


}


class Barcode_Image_Taker : UIViewController {
    var display_image : UIImageView = UIImageView()
    
    let camera_button : UIButton = {
        let bt = UIButton()
        bt.setTitle("Take Screenshot", for: .normal)
        bt.backgroundColor = UIColor.systemGreen
        bt.layer.cornerRadius = 10
        
        return bt
    }()
    
    @objc func usingBarcodeScanner(){
        let vc = BarcodeScanner()
        self.present(vc, animated : true)
    }
    
    func screen_shot(_ save : Bool = true) -> UIImage? {
        var screen_Image : UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext()
        else {return nil}
        layer.render(in: context)
        
        screen_Image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //way to save the screen shot at your photo album
        if let image = screen_Image, save {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        return screen_Image
    }
    @objc func take_action(){
        let output = screen_shot();
        display_image.image = output
    }
    func setup(){
        camera_button.frame = CGRect(x : 125, y: 300, width: 150, height: 50 )
        view.addSubview(camera_button)
        camera_button.addTarget(self, action: #selector(usingBarcodeScanner), for: .touchUpInside)
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        setup()
    }
}



