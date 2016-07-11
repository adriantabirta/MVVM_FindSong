//
//  DetailViewController.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/11/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playMorseBtn: UIButton!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var albumLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var song: Song
    
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
        self.priceLbl?.text = song.price.toSting()
        self.coverImage.imageFromUrl(song.coverUrl)
        
        
    }
    

}