//
//  AppleSongSearch.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/8/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation

protocol AppleSongSearch {
    
    
    // try first or secound
    func searchSongByTitle(searchString: String) -> String
    
    func  searchSongByArtist(searchString: String) -> String 
}
