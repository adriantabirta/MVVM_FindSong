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
    func onDataRecieve()
}

class ListVCViewModel {
    
    private var item = SongItem()
    private var limit = 10
    private var searchString = ""
    var songs: Array<SongItem> =  [] {
        didSet {
            self.listDelegate?.onDataRecieve()
        }
    }
    // TODO: Revise var/let usage all over the code
    let searchService: SearchServicesViewModel //= SearchServicesViewModel()
    //let searchDelegate: SearchServicesDelegate?
    var listDelegate: ListVCViewModelDelegate?
    
    init(searchServices: SearchServicesViewModel) {
        self.searchService = searchServices
        self.searchService.delegate = self
    }
   
    /**
     Get fisrt 10 songs from API
     
     - parameter searchText: artist or song name
     - parameter limitSearch: when is not set will return default 10 song items. 
        If is greater than 0 than will return default 10 + 10 songs each time when fung will be called
     */
    func getSongsByName(searchText: String, limitSearch : Int = 0) {
        self.searchString = searchText
        if limitSearch > 0 { self.limit += 10 }
        searchService.searchSongByTitle(searchText,  limit: self.limit)
    }
    
    // TODO: Remove this unuseful construction
    // TODO: Define a subscript for Array which will return `safely` the object at index
    
    /**
     Get `safely` song at index, if it`s out of range than return nil
     
     - parameter index: song index
     
     - returns: SongItem
     */
    func songAtIndex(index: Int) -> SongItem {
        guard let temp =  songs[safe: index] else {
            let some = SongItem()
            return some
        }
        return  temp
    }
    
    
    /**
     Remove song at index, if doesn`t exist then return nil
     
     - parameter index: object index
     */
    func removeSongAtIndex(index: Int) {
        guard  songs[safe: index] != nil else { return }
        songs.removeAtIndex(index)
    }
}

extension ListVCViewModel : SearchServicesDelegate {

    func dataRecieved() {
        self.songs.removeAll()
        self.songs = searchService.songs
    }
}
