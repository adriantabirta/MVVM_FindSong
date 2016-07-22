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

class DetailViewController: UIViewController {
    
    @IBOutlet  var playButton: UIButton!
    @IBOutlet  var playMorseButton: UIButton!
    @IBOutlet  var artistButton: UIButton!
    @IBOutlet  var albumButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet  var priceLabel: UILabel!
    @IBOutlet  var songLengthLabel: UILabel!
    @IBOutlet  var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var progress: UIProgressView!
    
    var morseCode : MorseCode?
    var modelview : DetailViewModel?
    let songIndex : Int
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()

     init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, songNr songAtIndex: Int) {
        self.songIndex = songAtIndex
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        edgesForExtendedLayout = .None
        self.modelview = DetailViewModel(songIndex: self.songIndex)
        self.artistButton?.setTitle( modelview?.getArtistName(), forState: UIControlState.Normal)
        self.albumButton?.setTitle( modelview?.getAlbumName(), forState: UIControlState.Normal)
        
        self.playButton.enabled = false
        self.playButton.layer.cornerRadius = 10
        self.playButton.layer.borderColor = UIColor.grayColor().CGColor
        self.playButton.layer.borderWidth = 2
        self.playButton.layer.masksToBounds = true
        self.playButton?.kf_setImageWithURL( modelview?.getCoverUrl(), forState: UIControlState.Normal)
        
        self.songLengthLabel?.text = modelview?.getSongLength()
        self.priceLabel?.text = modelview?.getPrice()
        guard let str = modelview?.getArtistName() else { return }
        self.morseCode = MorseCode(string: str )
        
        loadPlayer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        if self.morseCode?.isNowPlaying() == true {
            self.morseCode?.stopMorse()
        }
    }
    
    @IBAction func playTapped(sender: AnyObject) {
        if audioPlayer.playing {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
    
    @IBAction func playMorse(sender: AnyObject) {
        if let morseCode = self.morseCode {
            if morseCode.isNowPlaying() {
                morseCode.stopMorse()
                self.playMorseButton.setTitle("Start Morse", forState: UIControlState.Normal)
            }
            else {
                morseCode.playMorse( {
                  self.playMorseButton.setTitle("Start Morse", forState: UIControlState.Normal)
                } )
                self.playMorseButton.setTitle("Stop Morse", forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func artistTapped(sender: AnyObject) {
        guard let url = modelview?.getArtistUrl() else { return }
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func albumTapped(sender: AnyObject) {
         guard let url = modelview?.getAlbumtUrl() else { return }
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        // save local
        modelview?.saveSongWithUrl()
    }
}


extension DetailViewController : AVAudioPlayerDelegate {

    func loadPlayer() {
        self.activityIndicator.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            //self.initMusicPlayer()
            self.playLocal()
            dispatch_async(dispatch_get_main_queue()) {
                self.playButton.enabled = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func playLocal() {
    
        do {
            print( String( self.modelview?.getSongUrl()))
            guard let some =  modelview?.getSongUrl(), urlStr = APIServices.sharedInstance.localFilePathForUrl( String(some)) else {
                    print("nil local url song")
                    return
            }
            print(urlStr)
            self.audioPlayer =  AVAudioPlayer()
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: urlStr )
            self.audioPlayer.delegate = self
            self.audioPlayer.volume = 1.0
            self.audioPlayer.prepareToPlay()
            dispatch_async(dispatch_get_main_queue()) {
                self.playButton.enabled = true
                self.activityIndicator.stopAnimating()
            }
        }
        catch let error as NSError {
            print("Error init player \(error)")
        }

    }
    
    func initMusicPlayer() {
        do {
            guard let urlStr = modelview?.getSongUrl(),
                soundData =  NSData(contentsOfURL: urlStr) else {
                    print("nil url song")
                    return
            }
            self.audioPlayer =  AVAudioPlayer()
            self.audioPlayer = try AVAudioPlayer(data: soundData)
            self.audioPlayer.delegate = self
            self.audioPlayer.volume = 1.0
            self.audioPlayer.prepareToPlay()
            dispatch_async(dispatch_get_main_queue()) {
                self.playButton.enabled = true
                self.activityIndicator.stopAnimating()
            }
        }
        catch let error as NSError {
            print("Error init player \(error)")
        }
    }
}



