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
        
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        
        var dic: NSMutableDictionary = ["":""]
        var song: Song
        var songList: Array<Song> = []
        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        
         let mySearchString =  searchString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        guard mySearchString.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet) != nil, let urlPath: String = "https://itunes.apple.com/search?term=\(mySearchString)&limit=10", url: NSURL = NSURL(string: urlPath)  else {
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
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
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
    
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        return songList
    }
    
    
    func searchSongByTitle2(searchString: String) -> Array<Song>{
       // var song: Song
        var songList: Array<Song> = []
        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
      //  let queue: NSOperationQueue = NSOperationQueue()
    
        let mySearchString =  searchString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        guard let url = NSURL(string: "https://itunes.apple.com/search?term=\(mySearchString)&limit=10"),  request: NSMutableURLRequest = NSMutableURLRequest(URL: url) where
            searchString.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet) != nil else {
            print("search string is nil")
            return songList
        }
        


        do {
            
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
           // let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request, completionHandler: {
                data, response, error  in
                
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 200 {
                    
                        print("AM PRIMIT \(data)")
                    }
                }
                
            })
            task.resume()
            
          //  NSURLSession.da
//                try NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {
//                   response, data, error  in
//                })
            
        }catch {
        
        }
        
        
        return songList
    }
   
    
}

