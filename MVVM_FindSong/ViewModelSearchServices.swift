//
//  ViewModelServices.swift
//  MVVM_FindSong
//
//  Created by adriantabirta on 13.07.2016.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation

protocol ViewModelSearchServices {
    
       func searchSongByTitle(searchString: String) -> Array<Song>
}

extension ViewModelSearchServices {
    
    func searchSongByTitle(searchString: String) -> Array<Song>{
        
        var dic: NSMutableDictionary = ["":""]
        var song: Song
        var songList: Array<Song> = []
        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        // check ???
       let mySearchString =  searchString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        guard mySearchString.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet) != nil,  let urlPath: String = "https://itunes.apple.com/search?term=\(mySearchString)&limit=10", url: NSURL = NSURL(string: urlPath)  else {
            print(" roare la crearea url-lui")
            songList.removeAll()
            return songList
        }
        
        
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do{
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? NSMutableDictionary {
                    dic = jsonResult
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
        guard dic.objectForKey("results") != nil else {
            print(" response dic nil")
            songList.removeAll()
            return songList
        }
        
        
        if let  responseArray = dic.objectForKey("results") as? NSMutableArray {
            for item in responseArray {
                song = Song( title: item.objectForKey("trackName" ) as? String,
                             artist: item.objectForKey("artistName" ) as? String,
                             album: item.objectForKey("collectionName" ) as? String,
                             songUrl: item.objectForKey("previewUrl" ) as? String,
                             coverUrl: item.objectForKey("artworkUrl100" ) as? String,
                             songLength: item.objectForKey("trackTimeMillis" ) as? String ,
                             price: item.objectForKey("trackPrice" ) as? Float )
                
                songList.append(song)
            }
            
            
        }
        
        return songList
    }
}