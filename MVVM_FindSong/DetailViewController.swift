//
//  DetailViewController.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/11/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox
import MediaPlayer



class DetailViewController: UIViewController, AVAudioPlayerDelegate, Player {

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playMorseBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var albumLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var songLength: UILabel!
    
    var song: ListVCViewModel.Item
    var delegate: Player?
    var torchOn: Bool = false
    var isPlaying: Bool = false
    private var audioPlayer: AVAudioPlayer
    private  let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
 
    
    init(song: ListVCViewModel.Item) {
        self.song = song
        self.audioPlayer =  AVAudioPlayer()
        super.init(nibName: "DetailViewController", bundle: nil)
        edgesForExtendedLayout = .None
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlayer()
        self.titleLbl?.text = song.title
        self.albumLbl?.text = song.album
        self.priceLbl?.text = song.price
        self.songLength?.text = song.songLength
        self.playBtn.nsDownloadImage(song.coverUrl!)
    }
    
    @IBAction func playTapped(sender: AnyObject) {

        if isPlaying {
            audioPlayer.pause()
            isPlaying = false
        }else {
            audioPlayer.play()
            isPlaying = true
        }
 
    }
    
    @IBAction func playMorse(sender: AnyObject) {
        
        print("tap morse")
        
            if (device.hasTorch) {
                do {
                    try device.lockForConfiguration()
                    try device.setTorchModeOnWithLevel(1.0)
                    if torchOn {
                        device.torchMode = AVCaptureTorchMode.Off
                        torchOn = false
                        print("OFF")
                    } else {
                        device.torchMode == AVCaptureTorchMode.On
                         AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                        torchOn = true
                        print("ON")
                    }
                    device.unlockForConfiguration()
                }
                catch {
                 print("error flash")
                }
        }
    }
    
    func initPlayer() {
    
        do{
            guard let url = self.song.songUrl,
            soundData = NSData(contentsOfURL:url) else { return }
            audioPlayer = try AVAudioPlayer(data: soundData)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.delegate = self
            //audioPlayer.play()
        }
        catch let error as NSError {
            print("Error init player")
        }
        
    }
    
    func morse() {
    
    //
        for(var i=0; i<song.title?.characters.count; i+=1) {
        
            let str: String = morseCodeDict.objectForKey("a") as! String
            for char in str.characters {
                print(char)
                switch char {
                case " " :
                    print("space")
                    
                    
                case ".":
                    print("dot")
                    
                    
                case "-":
                    print("line")
                    
                    
                default: break
                    
                    
                    
                }
                
            }
            
          /*
            switch song.title?.startIndex.advancedBy(i) {
            case " ": {
                
                }
                
            case ".": {
                
                }
            default: {
                
                }
                
            }
            
            */
        }
        
    }
    
    
    func playDot() {}
    
    func playLine() {}
    
    func playSpace() {}
    

}


