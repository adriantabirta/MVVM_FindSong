//
//  WebViewController.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/15/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
import UIKit
import Foundation

class WebViewController : UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var searchString : String?
    
    init(string: String) {
        print(string)
        self.searchString = string
        super.init(nibName: "WebViewController", bundle: nil)
        edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let str: String = searchString, str2: String = str.stringByReplacingOccurrencesOfString(" ", withString: "+"),
            url = NSURL(string: "https://www.google.com/search?q=\(str2)") else { return }
        webView.loadRequest(NSURLRequest(URL:url ))
    }
    
}