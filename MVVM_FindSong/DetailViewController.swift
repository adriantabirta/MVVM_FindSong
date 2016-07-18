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
    var morseCode: MorseCode?
    var torchOn: Bool = false
    var isPlaying: Bool = false
    var isPlayingMorse: Bool = false
    var morseThread: NSThread?
    var token : dispatch_once_t = 0
    private var audioPlayer: AVAudioPlayer
    //private  let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
 
    
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
        guard let urlStr = song.coverUrl, url = NSURL(string: urlStr) else { return }
        self.playBtn.enabled = false
        //self.playBtn.nsDownloadImage(url)
        self.playBtn.kf_setImageWithURL(url, forState: UIControlState.Normal)
        guard let str = song.artist else { return }
        self.morseCode = MorseCode(string: str )
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
      
  
        if let morseCode = self.morseCode {
            if morseCode.isNowPlaying() {
                morseCode.stopMorse()
                self.playMorseBtn.setTitle("Start Morse", forState: UIControlState.Normal)
            }
            else {
                morseCode.playMorse( {
                  self.playMorseBtn.setTitle("Start Morse", forState: UIControlState.Normal)
                } )
                self.playMorseBtn.setTitle("Stop Morse", forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func artistTapped(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: (self.song.artistUrl)!)!)
        /*
        guard let myString = song.artistUrl, wvc : WebViewController = WebViewController(string: myString) else {
            return
        }
        self.navigationController?.pushViewController(wvc, animated: true)
        */
    }
    
    @IBAction func albumTapped(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: (self.song.albumUrl)!)!)
        /*
        guard let myString = song.albumUrl, wvc : WebViewController = WebViewController(string: myString) else {
            return
        }
        self.navigationController?.pushViewController(wvc, animated: true)
        */
    }
    
    func initPlayer() {
    
        self.activityIndicator.startAnimating()
        
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
    
    override func viewDidAppear(animated: Bool) {
        print("dispare !!!")
        if self.morseCode?.isNowPlaying() == true {
        self.morseCode?.stopMorse()
        }
    
    }
    

}


