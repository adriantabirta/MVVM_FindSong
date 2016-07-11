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
    
 //   var songList: Array<Song> { get set }
    func searchSongByTitle(searchString: String) -> Array<Song>

}

extension AppleSongSearch {
    
     func searchSongByTitle(searchString: String) -> Array<Song>{
        
        var dic: NSDictionary = ["":""]
        var song: Song
        var songList: Array<Song> = []
        
        let urlPath: String = "https://itunes.apple.com/search?term=jack+johnson&limit=10"
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        
        do{
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
            print(response)
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? NSDictionary {
                  // print("Synchronous\(jsonResult.objectForKey("trackName"))")
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
        
        //print("=>> \((dic.objectForKey("results") as! NSObject))")
       // print(" ==> \(arr.objectAtIndex(0).objectForKey("artistName"))")
        
        for item in arr {
             song = Song(title: item.objectForKey("trackName" ) as! String,
                            artist: item.objectForKey("artistName" ) as! String,
                            album: item.objectForKey("collectionName" ) as! String,
                            songUrl:NSURL(fileURLWithPath: (item.objectForKey("previewUrl" ) as! String)),
                            coverUrl: NSURL(fileURLWithPath: (item.objectForKey("artworkUrl100" ) as! String)),
                            songLength: 1.1,
                            price: 1.99)
                
            songList.append(song)
 
        }
        
        
       // print(songList)
        return songList
    }
    
   
    
}



extension UIImageView {
    
    public func imageFromUrl(url: NSURL) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
}