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
    var delegate: SearchServicesDelegate?
    var songs: Array<SongItem> = []  {
        didSet {
             delegate?.updateData()
             UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func updateData() { }
}

extension SearchServicesViewModel {

    func searchSongByTitle(searchString: String, limit: Int) {
        var song: SongItem = SongItem()
        self.songs.removeAll()
        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let mySearchString =  searchString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        guard let url = NSURL(string: "https://itunes.apple.com/search?term=\(mySearchString)&limit=\(limit)"),  request: NSMutableURLRequest = NSMutableURLRequest(URL: url) where
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
                                return self.songs  = Array<SongItem>()
                            }
                            
                            if let  responseArray = jsonResponse.objectForKey("results") as? NSMutableArray {
                                var temp : Array<SongItem> = []
                                for item in responseArray {
                                    song = SongItem()
                                        song.title = item.objectForKey("trackName" ) as? String
                                        song.artist = item.objectForKey("artistName" ) as? String
                                        song.album = item.objectForKey("collectionName" ) as? String
                                        song.songUrl = item.objectForKey("previewUrl" ) as? String
                                        song.coverUrl = item.objectForKey("artworkUrl100" ) as? String
                                        song.artistUrl = item.objectForKey("artistViewUrl" ) as? String
                                        song.albumUrl = item.objectForKey("collectionViewUrl" ) as? String
                                        song.songLength = item.objectForKey("trackTimeMillis" ) as? NSNumber
                                        song.price = item.objectForKey("trackPrice" ) as? Float
                                    temp.append(song)
                                }
                                
                                if temp.count > 10 {
                                    print("mai mult de 10")
                                    self.songs = temp.getLastTenItems()
                                } else {
                                  self.songs = temp
                                }
                                  print("date receptionate !!! \(temp.count) elemente")
                            }
                        }
                        catch {
                            print("eroare primire date")
                        }
                    }
                }
                
            })
            task.resume()
        }catch { }
    }
}