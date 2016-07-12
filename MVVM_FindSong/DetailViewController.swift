//
//  DetailViewController.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/11/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import UIKit
import MediaPlayer
import Foundation

class DetailViewController: UIViewController, Player {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playMorseBtn: UIButton!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var albumLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var song: Song
    var delegate: Player?
    
    init(song: Song) {
        self.song = song
        super.init(nibName: "DetailViewController", bundle: nil)
        edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl?.text = song.title
        self.albumLbl?.text = song.album
        self.priceLbl?.text = song.price!.toSting()
        self.coverImage?.image = song.coverImage
        self.coverImage.downloadImage(NSURL(string:song.coverUrl! as String )!)
    }
    
    @IBAction func playTapped(sender: AnyObject) {
     playSong(self.song)
    }

 

}