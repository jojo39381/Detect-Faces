//
//  ViewController.swift
//  DetectFaces
//
//  Created by Joseph Yeh on 11/24/20.
//

import UIKit
import AVKit
import Vision
import MLKitFaceDetection
import MLKitVision
class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let identifierLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "welcome"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let options = FaceDetectorOptions()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupIdentifierConfidenceLabel()
        options.performanceMode = .accurate
        options.landmarkMode = .all
        options.classificationMode = .all

        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            captureSession.startRunning()
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            view.layer.addSublayer(previewLayer)
            
            let dataOutput = AVCaptureVideoDataOutput()
            
            
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(dataOutput)
            
            previewLayer.frame = view.frame
            
        }
        catch {
            
        }
        
       
    }


  
    
    
    
    fileprivate func setupIdentifierConfidenceLabel() {
        view.addSubview(identifierLabel)
        identifierLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        identifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        identifierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        identifierLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        let image = VisionImage(buffer: sampleBuffer)
        let orientation = Utils.imageOrientation(
            fromDevicePosition: .front
            )

            image.orientation = orientation
        let faceDetector = FaceDetector.faceDetector(options: options)
        faceDetector.process(image) { faces, error in
          guard error == nil, let faces = faces, !faces.isEmpty else {
            
            return
          }

            self.processOutput(results: faces)
          
        }

    }

    func processOutput(results: [Face]) {
        
        
        
        identifierLabel.text = "\(results.count) Passengers in the car"
    }
}



