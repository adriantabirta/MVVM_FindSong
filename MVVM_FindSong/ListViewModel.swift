//
//  ListVCViewModel.swift
//  MVVM_FindSong
//
//  Created by adriantabirta on 13.07.2016.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation


protocol ListViewModelDelegate : class {
    func onDataRecieve()
}

class ListViewModel {
    
    weak var listDelegate: ListViewModelDelegate?
    
    private var item = SongItem()
    private var limit = 10
    private var searchString = ""
    var songs: Array<SongItem> =  [] {
        didSet { self.listDelegate?.onDataRecieve() }
    }
    
    init() {
        APIServices.sharedInstance.delegate = self
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
        APIServices.sharedInstance.searchSongByTitle(searchText, limit: self.limit)
    }
    
    func getSearchText() -> String {
        return self.searchString
    }
    
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
    
    func getWebData() {
        self.songs.removeAll()
        self.songs =  APIServices.sharedInstance.songs
    }
    
    func getLocalData() {
        // load list of saved songs
        self.songs.removeAll()
    }
}

extension ListViewModel : APIServicesDelegate {

    func dataRecieved() {
        self.songs.removeAll()
        self.songs =  APIServices.sharedInstance.songs
    }
}
