//
//  AppleSongSearch.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/8/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation



protocol AppleSongSearch: class {

    func searchSongByTitle(searchString: String) -> Array<Song>

}

extension AppleSongSearch {
    
     func searchSongByTitle(searchString: String) -> Array<Song>{
        
        var dic: NSDictionary = ["":""]
        var song: Song
        var songList: Array<Song> = []
        
        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        let searchTerm = searchString.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet)!

        
        let urlPath: String = "https://itunes.apple.com/search?term=\(searchTerm)&limit=10"
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        do{
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? NSDictionary {
                 dic = jsonResult
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
        
        var arr: NSMutableArray
        arr = (dic.objectForKey("results") as! NSObject) as! NSMutableArray
        
  
        
        for item in arr {
            song = Song( title: item.objectForKey("trackName" ) as? String,
                         artist: item.objectForKey("artistName" ) as? String,
                         album: item.objectForKey("collectionName" ) as? String,
                         songUrl: item.objectForKey("previewUrl" ) as? String,
                         coverUrl: item.objectForKey("artworkUrl100" ) as? String,
                         coverImage: UIImage(),
                         songLength: (item.objectForKey("trackTimeMillis" ) as! Float )/1000,
                         price: item.objectForKey("trackPrice" ) as? Float )
            
            songList.append(song)
           // print(song.title)
 
        }
   
      //  print(songList)
        return songList
    }
    
   
    
}

