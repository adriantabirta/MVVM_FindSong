//
//  ListVCViewModel.swift
//  MVVM_FindSong
//
//  Created by adriantabirta on 13.07.2016.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation

public struct SongItem {
    
    var title: String?
    var artist: String?
    var album: String?
    var songUrl: NSURL?
    var coverUrl: NSURL?
    var songLength: String?
    var price: String?
    var image: UIImage?
}

protocol ListVCViewModelDelegate {
    func updateDataInTable()
}

class ListVCViewModel: SearchServicesDelegate , ListVCViewModelDelegate {
    
    private var item: SongItem = SongItem()
    var songs: Array<Song> =  [] {
        didSet {
            print("setat in model view array-ul, cheama delegatul")
            self.listDelegate?.updateDataInTable()
        }
    }
    var searchService: SearchServicesViewModel = SearchServicesViewModel()
    var searchDelegate: SearchServicesDelegate?
    var listDelegate: ListVCViewModelDelegate?
    
    init(searchServices: SearchServicesViewModel) {
        self.searchService = searchServices
        self.searchService.delegate = self
        
    }
    
    func updateData() {
       self.songs = searchService.songs
       print("in view model ")
    }
    
    func updateDataInTable() {
        
    }
    
    func getSongsByName(searchText: String){
      searchService.searchSongByTitle2(searchText)
    }
    
    func songAtIndex(index: Int) ->SongItem {
     
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
        
        print(some)
        
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
       
        print("itemul returnat \(item)")
        return item
    }
    
    func removeSongAtIndex(index: Int) {
        songs.removeAtIndex(index)
    }
 
}