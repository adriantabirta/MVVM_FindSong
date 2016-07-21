//
//  SongCellModelView.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/21/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation

class SongCellModelView {

    init() {
       }
    
    func saveSongWithUrl(url: NSURL)  {
        // do save
        APIServices.sharedInstance.downloadAndSaveFileFromUrl(url) {
         
            ( path, error ) in
            // print file directory or error
            // save data in db & make UI stuff
            print("download completion handler")
            
        }
    }
}