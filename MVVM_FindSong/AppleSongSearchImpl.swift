//
//  AppleSongSearchImpl.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/8/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation

class AppleSongSearchImpl{
    
    
  //  private let requests: NSMutableSe
    
    
    init(){
    
    }
    
//    func searchSongByTitle(searchString: String) -> String {
//        // do some afnetworking async
//        
//        let urlPath: String = "https://itunes.apple.com/search?term=jack+johnson&limit=2"
//        let url: NSURL = NSURL(string: urlPath)!
//        let request1: NSURLRequest = NSURLRequest(URL: url)
//        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
//        
//        
//        do{
//            
//            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
//            
//            print(response)
//            do {
//                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? NSDictionary {
//                    print("Synchronous\(jsonResult)")
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//            
//            
//            
//        }catch let error as NSError
//        {
//            print(error.localizedDescription)
//        }
//        
//        return " "
//    }
    
//    func searchSongByArtist(searchString: String) -> String {
//        // do some afnetworking async
//        return " "
//    }
}


//extension AppleSongSearch{
//    
//    func searchSongByTitle(searchString: String) -> String{
//    
//        let urlPath: String = "https://itunes.apple.com/search?term=jack+johnson&limit=2"
//        let url: NSURL = NSURL(string: urlPath)!
//        let request1: NSURLRequest = NSURLRequest(URL: url)
//        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
//        
//        
//        do{
//            
//            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
//            
//            print(response)
//            do {
//                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? NSDictionary {
//                    print("Synchronous\(jsonResult)")
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//            
//            
//            
//        }catch let error as NSError
//        {
//            print(error.localizedDescription)
//        }
//    
//    }
//    
//    
//}