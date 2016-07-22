//
//  DetailVCViewModel.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/19/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation

class DetailViewModel {

    let songIndex : Int

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(songIndex: Int) {
        print("my index: \(songIndex)")
        self.songIndex = songIndex
    }

    func getArtistName () -> String {
        guard let some = APIServices.sharedInstance.songs[self.songIndex].artist else { return "" }
        return some
    }
    
    func getAlbumName () -> String {
        guard let some = APIServices.sharedInstance.songs[self.songIndex].album else { return "" }
        return some
    }
    
    func getCoverUrl () -> NSURL {
        guard let some = APIServices.sharedInstance.songs[self.songIndex].coverUrl, url = NSURL( string: some )  else {
            return NSURL()
        }
        return url
    }
    
    func getSongUrl () -> NSURL {
        guard let some = APIServices.sharedInstance.songs[self.songIndex].songUrl, url = NSURL( string: some ) else { return NSURL() }
        return url
    }
    
    func getArtistUrl () -> NSURL {
        guard let some = APIServices.sharedInstance.songs[self.songIndex].artistUrl, url = NSURL( string: some )  else { return NSURL() }
        return url
    }
    
    func getAlbumtUrl () -> NSURL {
        guard let some = APIServices.sharedInstance.songs[self.songIndex].albumUrl, url = NSURL( string: some )  else { return NSURL() }
        return url
    }
    
    func getPrice () -> String {
        guard let some = APIServices.sharedInstance.songs[self.songIndex].price else { return "" }
        return some.asLocaleCurrency
    }
    
    func getSongLength () -> String {
        guard let some = APIServices.sharedInstance.songs[self.songIndex].songLength else { return "" }
        return convertToMinAndSec(some)
    }
    
    
    
    func printall() {
        print(getArtistName())
        print(getSongUrl())
        print(getCoverUrl())
    }
    
    func saveSongWithUrl()  {
        // do save
        APIServices.sharedInstance.downloadAndSaveFileFromUrl(getSongUrl()) {
            
            ( path, error ) in
            // print file directory or error
            // save data in db & make UI stuff
            print("download completion handler")
            
        }
    }
    
    func deleteSongAtIndex(index: Int) {
        // delete song from DB and locallly
    }
}
