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

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playMorseBtn: UIButton!
    @IBOutlet weak var artistBtn: UIButton!
    @IBOutlet weak var albumBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var songLength: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var song: SongItem
    var morseCode: MorseCode?
    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
  
    init(song: SongItem) {
        self.song = song
        super.init(nibName: "DetailViewController", bundle: nil)
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlayer()
        self.activityIndicator.hidesWhenStopped = true
        edgesForExtendedLayout = .None
    }
    
    /// init music player
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
    }
    
    @IBAction func albumTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: (self.song.albumUrl)!)!)
    }
    
    func loadPlayer() {
        self.activityIndicator.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            self.initMusicPlayer()
            dispatch_async(dispatch_get_main_queue()) {
                self.playBtn.enabled = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func initMusicPlayer() {
        do {
            guard let urlStr =  self.song.songUrl,
                url = NSURL(string: urlStr),
                soundData =  NSData(contentsOfURL:url) else {
                print("nil url song")
                return
            }
            self.audioPlayer =  AVAudioPlayer()
            self.audioPlayer = try AVAudioPlayer(data: soundData)
            self.audioPlayer.delegate = self
            self.audioPlayer.volume = 1.0
            self.audioPlayer.prepareToPlay()
            dispatch_async(dispatch_get_main_queue()) {
                self.playBtn.enabled = true
                self.activityIndicator.stopAnimating()
            }
        }
        catch let error as NSError {
            print("Error init player \(error)")
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("dispare !!!")
        if self.morseCode?.isNowPlaying() == true {
            self.morseCode?.stopMorse()
        }
    }
}


extension DetailViewController : AVAudioPlayerDelegate {

    //
}

extension DetailViewController {

    func configureDetailView(song: SongItem) {
        self.artistBtn.setTitle(song.artist, forState: UIControlState.Normal)
        self.albumBtn.setTitle(song.album, forState: UIControlState.Normal)
        guard let urlStr = song.coverUrl, url = NSURL(string: urlStr) else { return }
        self.playBtn.enabled = false
        self.playBtn.kf_setImageWithURL(url, forState: UIControlState.Normal)
        //self.priceLbl?.text = song.price?.converWithDollarSign()
        guard let time = song.songLength else { return }
        self.songLength?.text = convertToMinAndSec(time)
        guard let str = song.artist else { return }
        self.morseCode = MorseCode(string: str )
       
        self.priceLbl?.text = song.price?.asLocaleCurrency
        
    }
}



