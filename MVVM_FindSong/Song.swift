//
//  SongModel.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/8/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation

class Song{

    let title: String
    let artist: String
    let album: String
    let songUrl: NSURL
    let coverUrl: NSURL
    
    let songLength: Float
    let price: Float
    
    init(title: String, artist: String, album: String, songUrl: NSURL, coverUrl: NSURL, songLength: Float, price: Float) {
        self.title = title
        self.artist = artist
        self.album = album
        self.songUrl = songUrl
        self.coverUrl = coverUrl
        self.songLength = songLength
        self.price = price
    }
}