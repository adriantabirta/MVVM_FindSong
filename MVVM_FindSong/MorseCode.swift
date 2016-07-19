//
//  SongModel.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/8/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import UIKit


class MorseCode: NSObject {
    
    private var morseString: String = ""
    private var playThread: NSThread?
    private var isPlaying: Bool = false
    private var endPlayingHandler: (() -> ())?
    
    init(string: String) {
        super.init()
        self.morseString = MorseCode.getMorseStringFromString(string)
    }
    
    func playMorse(endPlayingHandler: () -> ()) {
        self.endPlayingHandler = endPlayingHandler
        self.playThread = NSThread(target: self, selector: #selector(MorseCode.playMorseThreadAction), object: nil)
        self.playThread?.start()
        self.isPlaying = true
    }
    
    func stopMorse() {
        self.playThread?.cancel()
        self.isPlaying = false
    }
    
    func isNowPlaying() -> Bool {
        return self.isPlaying
    }
    
    func playMorseThreadAction() {
        
        for character in self.morseString.characters {
            print(self.isNowPlaying())
            if !self.isPlaying {
                return
            }
            print(self.isNowPlaying())
            
            var numberOfBips = 1
            if character == "-" {
                numberOfBips = 3
            }
            
            for _ in 0..<numberOfBips {
                if !self.isPlaying {
                    return
                }
                
                DeviceManager.vibrate()
                DeviceManager.setTorchEnabled(true)
                DeviceManager.setTorchEnabled(false)
                NSThread.sleepForTimeInterval(0.5)
                
                if !self.isPlaying {
                    return
                }
            }
            
            if !self.isPlaying {
                return
            }
            
            NSThread.sleepForTimeInterval(1)
        }
        
        if let handler =  self.endPlayingHandler {
            handler()
        }
    }

    static func getMorseStringFromString(string: String) -> String {
        var morseString = ""
        for character in string.characters {
            morseString.appendContentsOf(getMorseCodeFromCharacter(character))
        }
        return morseString
    }

    static func getMorseCodeFromCharacter(character: Character) -> String {
        
        switch(character) {
            
        //Letters
        case "a", "A" :
            return ".-"
        case "b", "B" :
            return "-..."
        case "c", "C":
            return "-.-."
        case "d", "D":
            return "-.."
        case "e","E":
            return  "."
        case "f","F":
            return "..-."
        case "g","G":
            return "--."
        case "h","H":
            return "...."
        case "i","I":
            return ".."
        case "j","J":
            return ".---"
        case "K","k":
            return "-.-"
        case "l","L":
            return ".-.."
        case "m","M":
            return "--"
        case "n","N":
            return "-."
        case "o","O":
            return "---"
        case "p","P":
            return ".--."
        case "q","Q":
            return "--.-"
        case "r","R":
            return ".-."
        case "s","S":
            return "..."
        case "t","T":
            return "-"
        case "u","U":
            return "..-"
        case "v","V":
            return "...-"
        case "w","W":
            return ".--"
        case "x","X":
            return "-..-"
        case "y","Y":
            return "-.--"
        case "z","Z":
            return "--.."
            
        //Numbers
        case "1":
            return ".----"
        case "2":
            return "..---"
        case "3":
            return "...--"
        case "4":
            return "....-"
        case "5":
            return "....."
        case "6":
            return "-...."
        case "7":
            return "--..."
        case "8":
            return "---.."
        case "9":
            return "----."
        case "0":
            return "-----"
            
        //Other symbols
        case "(":
            return "-.--.-"
        case ")":
            return "-.--.-"
        case ",":
            return "--..--"
        case ".":
            return ".-.-.-"
        case " ":
            return ""
        default:
            return ""
        }    }
}
