//
//  CameraSession.swift
//  kalam
//
//  Created by mac on 04/12/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import AVFoundation

@objc protocol CameraSessionDelegate {
    func didOutput(_ sampleBuffer: CMSampleBuffer)
}

class CameraSession: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var session: AVCaptureSession?
    private var output: AVCaptureVideoDataOutput?
    private var device: AVCaptureDevice?
    weak var delegate: CameraSessionDelegate?
    
    override init() {
        super.init()
    }
    
    func setupSession(){
        self.session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSession.Preset.medium
        self.device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        guard let input = try? AVCaptureDeviceInput(device: device!) else {
            print("Caught exception!")
            return
        }
        
        self.session?.addInput(input)
        
        self.output = AVCaptureVideoDataOutput()
        let queue: DispatchQueue = DispatchQueue(label: "videodata", attributes: .concurrent)
        self.output?.setSampleBufferDelegate(self, queue: queue)
        self.output?.alwaysDiscardsLateVideoFrames = false
        self.output?.videoSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] as [String : Any]
        self.session?.addOutput(self.output!)
        
        self.session?.sessionPreset = AVCaptureSession.Preset.inputPriority
        self.session?.usesApplicationAudioSession = false
        
        self.session?.startRunning()
    }
    /// Swap camera and reconfigures camera session with new input
     func swapCamera() {

        // Get current input
        guard let input = self.session!.inputs[0] as? AVCaptureDeviceInput else { return }

        // Begin new session configuration and defer commit
        self.session?.beginConfiguration()
        defer { self.session?.commitConfiguration() }

        // Create new capture device
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }

        // Create new capture input
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
            print(error.localizedDescription)
            return
        }

        // Swap capture device inputs
        self.session?.removeInput(input)
        self.session?.addInput(deviceInput)
    }
    /// Create new capture device with requested position
    fileprivate func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {

        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices

        //if let devices = devices {
            for device in devices {
                if device.position == position {
                    return device
                }
            }
        //}

        return nil
    }
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.delegate?.didOutput(sampleBuffer)
    }
}
