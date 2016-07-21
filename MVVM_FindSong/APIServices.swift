//
//  ViewModelServices.swift
//  MVVM_FindSong
//
//  Created by adriantabirta on 13.07.2016.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation

protocol APIServicesDelegate : class {
    /**
     Called when searchServices get gata from API
     */
    func dataRecieved ()
}



class APIServices: NSObject {
    
    static let sharedInstance = APIServices()
    weak var delegate : APIServicesDelegate?
    private let apiLink = "https://itunes.apple.com/search?term="
    var songs: Array<SongItem> = []  {
        didSet {
             delegate?.dataRecieved()
             UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    private override init() { }
    
    func searchSongByTitle(searchString: String, limit: Int) {
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTaskWithRequest(prepareRequest(searchString, limit: limit), completionHandler: {
            data, response, error  in
            
            guard  let response2 = response as? NSHTTPURLResponse where response2.statusCode == 200, let newData = data  else { return }
            
            self.setSongs(self.getArrayFromData(newData))
            
        })
        task.resume()
    }

}


// MARK: - search songs private functions
extension APIServices {
    

    /**
     Build an request from a url string
     
     - parameter stringToPrepare: String which contain Url
     - parameter limit:           Parametter attached to link
     
     - returns: NSMutableURLRequest
     */
    private func prepareRequest(stringToPrepare: String, limit: Int) ->NSMutableURLRequest {
        
        let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        guard let mySearchString : String =  stringToPrepare.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch,
                  range: nil), url = NSURL(string: "\(apiLink)\(mySearchString)&limit=\(limit)"),
                  request: NSMutableURLRequest = NSMutableURLRequest(URL: url) where
                  stringToPrepare.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet) != nil
            else {
                print("search string is nil")
                return NSMutableURLRequest()
            }
        request.HTTPMethod = "GET"
        return request
    }
    
    /**
     Get an Array<SongItem> for given data.
     Data can be response from url request
     
     - parameter data: NSData
     
     - returns: Array<SongItem>
     */
    private func getArrayFromData( data: NSData ) -> Array<SongItem> {
        var temp : Array<SongItem> = []
        do {
             let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: [] )
             guard jsonResponse.objectForKey("results") != nil, let responseArray = jsonResponse.objectForKey("results") as? NSMutableArray else {
             return  Array<SongItem>()
            }
        
            for item in responseArray {
                mapArrayWithDic(item)
                temp.append( mapArrayWithDic(item))
            }
            setSongs(temp)
            print("date receptionate !!! \(temp.count) elemente")

         } catch { print("roare primire date")  }
     return temp
    }
    
    /**
     Return SongItem from an Item with type AnyObject
     
     - parameter item: Item from source
     
     - returns: SongItem
     */
   private func mapArrayWithDic( item : AnyObject ) -> SongItem {
        var song = SongItem()
        song.title = item.objectForKey("trackName" ) as? String
        song.title = item.objectForKey("trackName" ) as? String
        song.artist = item.objectForKey("artistName" ) as? String
        song.album = item.objectForKey("collectionName" ) as? String
        song.songUrl = item.objectForKey("previewUrl" ) as? String
        song.coverUrl = item.objectForKey("artworkUrl100" ) as? String
        song.artistUrl = item.objectForKey("artistViewUrl" ) as? String
        song.albumUrl = item.objectForKey("collectionViewUrl" ) as? String
        song.songLength = item.objectForKey("trackTimeMillis" ) as? NSNumber
        song.price = item.objectForKey("trackPrice" ) as? Float
        return song
    }
    
    /**
     This function set songs in self.songs. If array
     is greater than 10 than func will set last 10 items in self.song
     
     - parameter array: array that should be checked & set in self.songs
     */
    private func setSongs( array: Array<SongItem> ) {
        self.songs.removeAll()
        if array.count > 10 {
            self.songs = array.getLastTenItems()
        } else {
            self.songs = array
        }
    }
}

extension APIServices : NSURLSessionDelegate {

    /**
        Download file async for given url
     
     - parameter url:        File url
     - parameter completion: Completion handler return path where file is stored 
                             & error if file is not stored with succes
     */
    func downloadAndSaveFileFromUrl(url: NSURL, completion:(path:String, error:NSError!) -> Void) {
        
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        let destinationUrl = documentsUrl!.URLByAppendingPathComponent(url.lastPathComponent!)
        if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
            print("file already exists [\(destinationUrl.path!)]")
            
            completion(path: destinationUrl.path!, error:nil)
        } else {
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    if let response = response as? NSHTTPURLResponse {
                        print("response=\(response)")
                        if response.statusCode == 200 {
                            if data!.writeToURL(destinationUrl, atomically: true) {
                                print("file saved [\(destinationUrl.path!)]")
                                completion(path: destinationUrl.path!, error:error)
                            } else {
                                print("error saving file")
                                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                                completion(path: destinationUrl.path!, error:error)
                            }
                        }
                    }
                }
                else {
                    print("Failure: \(error!.localizedDescription)");
                    completion(path: destinationUrl.path!, error:error)
                }
            })
            task.resume()
        }
    }
    
    
    private func localFilePathForUrl(previewUrl: String) -> NSURL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.stringByAppendingPathComponent(lastPathComponent)
            return NSURL(fileURLWithPath:fullPath)
        }
        return nil
    }
    
    // This method checks if the local file exists at the path generated by localFilePathForUrl(_:)
    func localFileExistsForTrack(url: String) -> Bool {
        if let localUrl = localFilePathForUrl(url) {
            var isDir : ObjCBool = false
            if let path = localUrl.path {
                return NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)
            }
        }
        return false
    }
    
    private func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("download finish")
    
    }
    
    private func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    print("\(totalBytesWritten) from: \(totalBytesExpectedToWrite)")
    }

    

}


