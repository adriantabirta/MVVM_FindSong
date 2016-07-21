//
//  ExtensionsHelper.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/12/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import UIKit
import Foundation

func convertToMinAndSec(timeString: NSNumber) -> String {
    
    let nas = timeString.intValue / 1000
    let some = NSTimeInterval(NSNumber(int: nas))
    return some.minutesSeconds
}

extension  Array  {
    
    func getLastTenItems() ->  Array  {
       // print("get last 10 items")
        let range = self.count - 10..<self.count
        let temp = self[range]
     //   print("ultimile 10 rezultate \(temp)")
        return Array( temp )
    }
}

extension Float {

    var asLocaleCurrency:String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromNumber(self)!
    }
}

extension String  {
    
    func insert(string:String, ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
    
    func toUrl() -> NSURL {
        return NSURL(fileURLWithPath: self)
    }
}

extension NSTimeInterval {
    
    /// Minues : Seconds : Miliseconds time interval format
    var minuteSecondMS: String {
        print("converted format: \( String(format:"%d:%02d.%03d", minute , second, millisecond))")
        return String(format:"%d:%02d.%03d", minute , second, millisecond)
    }
    /// Minues : Seconds time interval format
    var minutesSeconds: String {
        return String(format:"%d:%02d", minute , second)
    }
    /// Minues time interval format
    var minute: Int {
        return Int((self / 60.0) % 60)
    }
    /// Seconds time interval format
    var second: Int {
        return Int(self % 60)
    }
    /// Miliseconds time interval format
    var millisecond: Int {
        return Int(self * 1000 % 1000 )
    }
}


extension CollectionType {
    /**
     Returns the element at the specified index iff it is within bounds, otherwise nil.
     
     
     - parameter index: Index for check
     
     - returns: element at index if exist
     */
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

