//
//  SongCell.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/11/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import UIKit
import Foundation

// TODO: make autolayout with less magic numbers
class SongCell: UITableViewCell  {

    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var songAlbum: UILabel!
    @IBOutlet weak var songLength: UILabel!
}


extension SongCell {

    func configureCellForSong(song: SongItem) {
        guard let imgUrlStr = song.coverUrl, url = NSURL(string: imgUrlStr) else {
            return
        }
        self.coverImg?.kf_setImageWithURL(url)
        self.title?.text = song.title
        self.songAlbum?.text = song.artist
        guard let time = song.songLength else {
            return
        }
        self.songLength?.text = convertToMinAndSec(time)
    }
 }
 
 