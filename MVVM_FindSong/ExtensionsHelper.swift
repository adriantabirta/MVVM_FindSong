//
//  ExtensionsHelper.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/12/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation

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

public extension  Array  {

    func getLastTenItems() ->  Array  {
        print("get last 10 items")
        var lastTen: Array = []
        var i: Int = 0
        
        repeat {
            lastTen.append(self.reverse()[i])
            i += 1
        } while  i < 10
        return lastTen
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
        let songLenght = String(format: "%d:%d", components.minute, components.second)
        return songLenght
    }
    
}

extension NSTimeInterval {
    
    /// Minues : Seconds : Miliseconds time interval format
    var minuteSecondMS: String {
        return String(format:"%d:%02d.%03d", minute , second, millisecond)
    }
    /// Minues : Seconds time interval format
    var minutesSeconds: String {
        return String(format:"%d:%02d", minute , second)
    }
    /// Minues time interval format
    var minute: Int {
        return Int((self/60.0)%60)
    }
    /// Seconds time interval format
    var second: Int {
        return Int(self % 60)
    }
    /// Miliseconds time interval format
    var millisecond: Int {
        return Int(self*1000 % 1000 )
    }
}

