//
//  ListViewController.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/8/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class ListViewController: UIViewController, AppleSongSearch {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myTable: UITableView!
    
    let searchBar = UISearchBar()
    var songList: Array<Song>  = []
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
       
      super.init(nibName: "ListViewController", bundle: nil)
        self.view.backgroundColor = UIColor.lightGrayColor()
        edgesForExtendedLayout = .None
        
        songList  = []
        let nib = UINib(nibName: "SongCell", bundle: nil)
        self.myTable.registerNib(nib, forCellReuseIdentifier: "Cell1")

        self.myTable.delegate = self
        self.myTable.dataSource = self
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        creaSearchBar()
    }
    
    
    func creaSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter song name"
        searchBar.text = ""
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
}

extension ListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
       
        searchBar.resignFirstResponder()
        self.songList.removeAll()
        
        guard let songtitle = searchBar.text else {
            print("nil song title")
            return
        }
        self.songList = searchSongByTitle(songtitle)
        self.myTable.reloadData()
    }
}


extension ListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
          searchBar.resignFirstResponder()
        let dvc: DetailViewController
        
        dvc = DetailViewController(song: songList[indexPath.row])
        self.navigationController?.pushViewController(dvc, animated: true)
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            songList.removeAtIndex(indexPath.row)
            self.myTable.reloadData()
        }
    }
}


extension ListViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! SongCell
        cell.title?.text = songList[indexPath.row].title
        cell.songAlbum?.text = songList[indexPath.row].album
        
        guard let url = songList[indexPath.row].coverUrl  else {
            return cell
        }
          cell.coverImg.downloadImage(NSURL(string:url)!)
        
        guard let some: NSString = songList[indexPath.row].songLength, sec: Int32 = some.intValue / 1000 else {
            return cell
        }
        
        //let sec = some.intValue
        
       // let secounds = NSString(string: songList[indexPath.row].songLength!).intValue / 1000
       let date: NSDate = NSDate(timeIntervalSince1970:NSTimeInterval( sec ))
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Minute, .Second], fromDate: date)
        print(components)
        cell.songLength?.text =  String(format: "%d:%d", components.minute, components.second)

        
 
        return cell
    }
}