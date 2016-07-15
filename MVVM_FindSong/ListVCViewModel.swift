//
//  ListVCViewModel.swift
//  MVVM_FindSong
//
//  Created by adriantabirta on 13.07.2016.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation


protocol ListVCViewModelDelegate {
    func updateDataInTable()
}

class ListVCViewModel: SearchServicesDelegate , ListVCViewModelDelegate {
    
    private var item: SongItem = SongItem()
    private var limit: Int = 10
    private var searchString: String = ""
    var songs: Array<SongItem> =  [] {
        didSet {
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
    }
    
    func updateDataInTable() {}
    
    func getSongsByName(searchText: String){
        self.searchString = searchText
        searchService.searchSongByTitle(searchText, limit: self.limit)
    }
    
    func loadMore() {
        searchService.searchSongByTitle(self.searchString, limit: self.limit+10)
    }
    
    func songAtIndex(index: Int) ->SongItem {
        let temp  = songs[index]
        item.title = temp.title
        item.artist = temp.artist
        item.album = temp.album
        item.songUrl = temp.songUrl
        item.songLength = temp.songLength
        item.coverUrl = temp.coverUrl
        item.artistUrl = temp.artistUrl
        item.albumUrl = temp.albumUrl
        item.price = temp.price
        item.image = UIImage()
        return item
    }
    
    func removeSongAtIndex(index: Int) {
        songs.removeAtIndex(index)
    }
 
}