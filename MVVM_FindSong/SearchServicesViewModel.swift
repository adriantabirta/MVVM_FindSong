//
//  ViewModelServices.swift
//  MVVM_FindSong
//
//  Created by adriantabirta on 13.07.2016.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation

protocol SearchServicesDelegate {
    
    func updateData ()
}

class SearchServicesViewModel: SearchServicesDelegate {
    
    var songs: Array<Song> = []  {
        didSet {
            print(" delegate services setat !!!")
             delegate?.updateData()
             UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    var delegate: SearchServicesDelegate?
  
    func updateData() {
        print("update func in services")
    }
}

extension SearchServicesViewModel {

    func searchSongByTitle2(searchString: String) {
        var song: Song = Song()
        var songList: Array<Song> = [] 
        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let mySearchString =  searchString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        guard let url = NSURL(string: "https://itunes.apple.com/search?term=\(mySearchString)&limit=10"),  request: NSMutableURLRequest = NSMutableURLRequest(URL: url) where
            searchString.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet) != nil else {
                print("search string is nil")
                return
        }
        
        
        do {
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request, completionHandler: {
                data, response, error  in
                
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 200 {
                        
                        guard let newData = data else { return }
                        
                        do {
                            let jsonResponse = try NSJSONSerialization.JSONObjectWithData(newData, options: [] )
                            guard jsonResponse.objectForKey("results") != nil else {
                                print(" response dic nil")
                                songList.removeAll()
                                return songList = Array<Song>()
                            }
                            
                            if let  responseArray = jsonResponse.objectForKey("results") as? NSMutableArray {
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
                            print("date receptionate !!!")
                            self.songs = songList
                        }
                        catch {
                            print("eroare primire date")
                        }
                    }
                }
                
            })
            task.resume()
        }catch {
            
        }
    }
}