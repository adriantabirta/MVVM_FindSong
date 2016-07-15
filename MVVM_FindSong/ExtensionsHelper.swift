//
//  ExtensionsHelper.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/12/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation

extension UIImageView {
    
    public func downloadImage(urlString: String) {
        
        guard let url = NSURL(string: urlString) else { return }
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(url) {
            
            (url: NSURL?, res: NSURLResponse?, e:NSError?) in
            guard let url2: NSURL = url, data = NSData(contentsOfURL:url2), imageDonloaded = UIImage(data: data)   else {
                print("image download  nil")
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.image = imageDonloaded
            }
        }
        task.resume()
    }
}

extension UIButton  {

    public func nsDownloadImage(urlString: String)  {

        guard let url = NSURL(string: urlString) else { return }
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(url) {
            
            (url: NSURL?, res: NSURLResponse?, e:NSError?) in
            guard let url2: NSURL = url, data = NSData(contentsOfURL:url2), imageDonloaded = UIImage(data: data)   else {
                print("image download  nil")
                return
            }
           // print(" imagine descarcata")
            dispatch_async(dispatch_get_main_queue()) {
             self.setImage(imageDonloaded, forState: UIControlState.Normal)
            }
        }
        task.resume()
    }
}

extension CollectionType {
    func last(count:Int) -> [Self.Generator.Element] {
        let selfCount = self.count as! Int
        if selfCount <= count - 1 {
            return Array(self)
        } else {
            return Array(self.reverse()[0...count - 1].reverse())
        }
    }
}

public extension Float {

    func converWithDollarSign() -> String {
        return String(format: "%0.2f $", self)
    }
}


public extension NSNumber {

    public func conevrtToTime() ->String {
        
        let string = NSString(format: "%d", self)
        let sec = string.intValue / 1000
        let date: NSDate = NSDate(timeIntervalSince1970:NSTimeInterval( sec ))
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Minute, .Second], fromDate: date)
        //print(components)
        let songLenght = String(format: "%d:%d", components.minute, components.second)
        
        return songLenght
    }
    
}



public extension String  {
    
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
    
    func toUrl() ->NSURL {
    
        return NSURL(fileURLWithPath: self)
    }
    
    public func conevrtToTime() ->String {
     
        let string = NSString(string: self)
        let sec = string.intValue / 1000
        let date: NSDate = NSDate(timeIntervalSince1970:NSTimeInterval( sec ))
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Minute, .Second], fromDate: date)
       // print(components)
        let songLenght = String(format: "%d:%d", components.minute, components.second)
       
        return songLenght
    }
    
}

