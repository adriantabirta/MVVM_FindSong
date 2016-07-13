//
//  ExtensionsHelper.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/12/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation

extension Float {
    
    func toStingAndDolarSing() -> String {
        
        return String(format: "%0.2f $", self)
    }
    
}

extension UIImageView {
    
    public func downloadImage(url: NSURL) {
        
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(url) {
            
            (url: NSURL?, res: NSURLResponse?, e:NSError?) in
            let data = NSData(contentsOfURL:url!)
            let imageDonloaded = UIImage(data: data!)
            print(" imagine descarcata")
            
            dispatch_async(dispatch_get_main_queue()) {
                self.image = imageDonloaded
            }
            
        }
        task.resume()
    }
}

extension UIButton  {

    public func nsDownloadImage(url: NSURL)  {
        
        let session = NSURLSession.sharedSession()
        var imageDonloaded: UIImage = UIImage()
        let task = session.downloadTaskWithURL(url) {
            
            (url: NSURL?, res: NSURLResponse?, e:NSError?) in
            let data = NSData(contentsOfURL:url!)
             imageDonloaded = UIImage(data: data!)!
            print(" imagine descarcata")
            
            dispatch_async(dispatch_get_main_queue()) {
             self.setImage(imageDonloaded, forState: UIControlState.Normal)
            
            }
            
        }
        task.resume()
      
    }
}
