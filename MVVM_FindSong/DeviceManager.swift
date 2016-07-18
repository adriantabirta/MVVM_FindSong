//
//  SongModel.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/8/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import UIKit

import AudioToolbox
import AVFoundation


class DeviceManager: NSObject {
    

    class func vibrate() {
        // Vibration
        if UIDevice.currentDevice().model == "iPhone" {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        else {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }

    class func setTorchEnabled(enabled: Bool) {
        // Torch
        if let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) {
            if device.hasTorch {
                do {
                    try device.lockForConfiguration()
                    if enabled {
                        device.torchMode = AVCaptureTorchMode.On
                        try device.setTorchModeOnWithLevel(1.0)
                    }
                    else {
                        device.torchMode = AVCaptureTorchMode.Off
                    }
                    device.unlockForConfiguration()
                }
                catch {
                    print("Torch is not available")
                }
            }
        }
    }
}
