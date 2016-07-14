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



class DetailViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playMorseBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var albumLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var songLength: UILabel!
    
    var song: SongItem
    var torchOn: Bool = false
    var isPlaying: Bool = false
    private var audioPlayer: AVAudioPlayer
    private  let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
 
    
    init(song: SongItem) {
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
       
        guard ((self.titleLbl?.text = song.title) != nil) else { return }
        self.albumLbl?.text = song.album
        self.priceLbl?.text = song.price?.converWithDollarSign()
        self.songLength?.text = song.songLength?.conevrtToTime()
        
      //  self.playBtn.nsDownloadImage(song.coverUrl!)
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
        morse()
        print("tap morse")
        
//            if (device.hasTorch) {
//                do {
//                    try device.lockForConfiguration()
//                    try device.setTorchModeOnWithLevel(1.0)
//                    if torchOn {
//                        device.torchMode = AVCaptureTorchMode.Off
//                        torchOn = false
//                        print("OFF")
//                    } else {
//                        device.torchMode == AVCaptureTorchMode.On
//                         AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//                        torchOn = true
//                        print("ON")
//                    }
//                    device.unlockForConfiguration()
//                }
//                catch {
//                 print("error flash")
//                }
//        }
    }
    
    func initPlayer() {
    
        do{
            guard let url =  self.song.songUrl?.toUrl(),
            soundData =  NSData(contentsOfURL:url) else { return }
            audioPlayer = try AVAudioPlayer(data: soundData)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.delegate = self
            //audioPlayer.play()
        }
        catch let error as NSError {
            print("Error init player \(error)")
        }
        
    }
    
    func morse() {
   
        var st: String = ""
        print(song.title)
        print(morseCodeDict.objectForKey("a"))
        
        for i: Character in (song.title?.characters)! {
        
            st.append(i)
            print(st)
      //  st.insert(i as Character, ind: 0)           // st.append(i)
            guard  let str: String = morseCodeDict.objectForKey(st) as? String else { return }
            print(str)
            for char in str.characters {
                print(char)
                switch char {
                case " " :
                    print("space")
                    
                    
                case ".":
                    print("dot")
                    playDot()
                    
                case "-":
                    print("line")
                    
                    
                default: break
                    
                    
                    
                }
                
            }
            
            st.removeAll()
 
        }
        
    }
    
    
    func playDot() {
        do {
        try device.lockForConfiguration()
        try device.setTorchModeOnWithLevel(1.0)
            device.torchMode = AVCaptureTorchMode.On
            sleep(1)
            device.torchMode = AVCaptureTorchMode.Off
        } catch {
        
        }
   
    }
    
    func playLine() {}
    
    func playSpace() {}
    

}


