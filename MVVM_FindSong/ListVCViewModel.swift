//
//  ListVCViewModel.swift
//  MVVM_FindSong
//
//  Created by adriantabirta on 13.07.2016.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation

class ListVCViewModel {
    
  // private let searchServices: ViewModelSearchServices
   private var item: Item
    var songs: Array<Song>
    
      init() {
        //super.init()
        //downloadInfo()
        songs = []
       // searchServices = ViewModelSearchServices()
        item = Item()
    }
    
    func songAtIndex(index: Int) ->Item {
     
        item.title = songs[index].title
        item.artist = songs[index].title
        item.album = songs[index].album

        guard let songUrl: String = songs[index].songUrl,  finalUrl = NSURL(string: songUrl) else {
            print("song url nil")
            return item
        }
        item.songUrl = finalUrl
        
        guard let some: NSString = songs[index].songLength, sec: Int32 = some.intValue / 1000 else {
            print("song lenght nil")
            return item
        }
        let date: NSDate = NSDate(timeIntervalSince1970:NSTimeInterval( sec ))
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Minute, .Second], fromDate: date)
        print(components)
        let songLenght = String(format: "%d:%d", components.minute, components.second)
        item.songLength = songLenght
        
        guard let coverUrl:String = songs[index].coverUrl, finalUrl2 = NSURL(string: coverUrl)  else {
            print(" cover url nil")
            return item
        }
        item.coverUrl = finalUrl2
        
        guard let price: Float = songs[index].price , price2: String = String(format: "%0.2f $", price) else {
        print(" price nil")
        return item
        }
        item.price = price2
        item.image = UIImage() // ?? //songs[index.row].coverUrl
       
        return item
    }
    
    func removeSongAtIndex(index: Int) {
        songs.removeAtIndex(index)
    }
    
    internal struct Item {
    
        var title: String?
        var artist: String?
        var album: String?
        var songUrl: NSURL?
        var coverUrl: NSURL?
        var songLength: String?
        var price: String?
        var image: UIImage?
    }
 
}