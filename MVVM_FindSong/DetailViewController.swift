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
    @IBOutlet weak var artistBtn: UIButton!
    @IBOutlet weak var albumBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var songLength: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var song: SongItem
    var torchOn: Bool = false
    var isPlaying: Bool = false
    var token : dispatch_once_t = 0
    private var audioPlayer: AVAudioPlayer
    private  let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
 
    
    init(song: SongItem) {
        self.song = song
        self.audioPlayer =  AVAudioPlayer()
        super.init(nibName: "DetailViewController", bundle: nil)
        // initPlayer()
        edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlayer()
        self.activityIndicator.hidesWhenStopped = true
        self.artistBtn.setTitle(song.artist, forState: UIControlState.Normal)
        self.albumBtn.setTitle(song.album, forState: UIControlState.Normal)
        self.priceLbl?.text = song.price?.converWithDollarSign()
        self.songLength?.text = song.songLength?.conevrtToTime()
        guard let url = song.coverUrl else { return }
        self.playBtn.enabled = false
        self.playBtn.nsDownloadImage(url)
        
        
       // self.playBtn.setImage(UIImage(named: "play-btn.png"), forState: UIControlState.Disabled)
        //playBtn(UIImage(named: "play-btn.png"), forState: UIControlState.Disabled)
        
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
    }
    
    @IBAction func artistTapped(sender: AnyObject) {
        guard let myString = song.artistUrl, wvc : WebViewController = WebViewController(string: myString) else {
            return
        }
        self.navigationController?.pushViewController(wvc, animated: true)
    }
    
    @IBAction func albumTapped(sender: AnyObject) {
        guard let myString = song.albumUrl, wvc : WebViewController = WebViewController(string: myString) else {
            return
        }
        self.navigationController?.pushViewController(wvc, animated: true)
    }
    
    func initPlayer() {
    
        self.activityIndicator.startAnimating()
   /*
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            print("This is run on the background queue")
            do{
                guard let urlStr =  self.song.songUrl, url = NSURL(string: urlStr), soundData =  NSData(contentsOfURL:url) else {
                    print("nil url song")
                    return
                }
                self.audioPlayer = try AVAudioPlayer(data: soundData)
                self.audioPlayer.delegate = self
                self.audioPlayer.volume = 1.0
                self.audioPlayer.prepareToPlay()
                // audioPlayer.play()
            }
            catch let error as NSError {
                print("Error init player \(error)")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print("This is run on the main queue, after the previous code in outer block")
                  self.playBtn.enabled = true
            })
        })
        */
        
        
        
        dispatch_async(dispatch_get_main_queue()) {
        do{
            guard let urlStr =  self.song.songUrl, url = NSURL(string: urlStr), soundData =  NSData(contentsOfURL:url) else {
                print("nil url song")
                return
            }
            self.audioPlayer = try AVAudioPlayer(data: soundData)
            self.audioPlayer.delegate = self
            self.audioPlayer.volume = 1.0
            self.audioPlayer.prepareToPlay()
           // audioPlayer.play()
        }
        catch let error as NSError {
            print("Error init player \(error)")
        }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.playBtn.enabled = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    
    func morse() {
        guard let t = song.title else { return }

        for i in (t.characters) {

        for var char in getMorseCodeForCharacter(i).characters  {
            
            switch  char {
            case " " :
                print("space")
                playSpace()
                
            case ".":
                print("dot")
                playDot()
                
            case "-":
                print("line")
                playLine()
                
            default: break
                
                
                
            }
            
            }
        }
        
    }
    
    
    func playDot() {
        do {
        try device.lockForConfiguration()
        try device.setTorchModeOnWithLevel(1.0)
            device.torchMode = AVCaptureTorchMode.On
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            NSThread.sleepForTimeInterval(0.1)
            device.torchMode = AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        } catch {
        
        }
   
    }
    
    func playLine() {
    
        do {
            try device.lockForConfiguration()
            try device.setTorchModeOnWithLevel(1.0)
            device.torchMode = AVCaptureTorchMode.On
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            NSThread.sleepForTimeInterval(0.3)
            device.torchMode = AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        } catch {
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if audioPlayer.data != nil {
        self.audioPlayer.stop()
        }
    }
 
    
    func playSpace() {
        NSThread.sleepForTimeInterval(0.7)
    }
    
    
      func getMorseCodeForCharacter(char: Character) -> String {
        
        switch(char) {
            
        //Letters
        case "a", "A" :
            return ".-"
        case "b", "B" :
            return "-..."
        case "c", "C":
            return "-.-."
        case "d", "D":
            return "-.."
        case "e","E":
            return  "."
        case "f","F":
            return "..-."
        case "g","G":
            return "--."
        case "h","H":
            return "...."
        case "i","I":
            return ".."
        case "j","J":
            return ".---"
        case "K","k":
            return "-.-"
        case "l","L":
            return ".-.."
        case "m","M":
            return "--"
        case "n","N":
            return "-."
        case "o","O":
            return "---"
        case "p","P":
            return ".--."
        case "q","Q":
            return "--.-"
        case "r","R":
            return ".-."
        case "s","S":
            return "..."
        case "t","T":
            return "-"
        case "u","U":
            return "..-"
        case "v","V":
            return "...-"
        case "w","W":
            return ".--"
        case "x","X":
            return "-..-"
        case "y","Y":
            return "-.--"
        case "z","Z":
            return "--.."
            
        //Numbers
        case "1":
            return ".----"
        case "2":
            return "..---"
        case "3":
            return "...--"
        case "4":
            return "....-"
        case "5":
            return "....."
        case "6":
            return "-...."
        case "7":
            return "--..."
        case "8":
            return "---.."
        case "9":
            return "----."
        case "0":
            return "-----"
            
        //Other symbols
        case "(":
            return "-.--.-"
        case ")":
            return "-.--.-"
        case ",":
            return "--..--"
        case ".":
            return ".-.-.-"
        case " ":
            return ""
        default:
            return ""
        }
    }


}


