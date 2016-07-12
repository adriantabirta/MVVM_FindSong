//
//  ListViewController.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/8/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation
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
        
        let nib = UINib(nibName: "SongCell", bundle: nil)
        self.myTable.registerNib(nib, forCellReuseIdentifier: "Cell1")

        self.myTable.delegate = self
        self.myTable.dataSource = self

        songList  = searchSongByTitle(searchBar.text!)
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        creaSearchBar()
    }
    
    
    func creaSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter song name"
        searchBar.text = "Carlas Dreams"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
}

extension ListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.songList.removeAll()
        self.songList = searchSongByTitle(searchBar.text!)
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
        cell.price?.text =  String(format: "%0.2f $", songList[indexPath.row].price!)
        cell.coverImg.downloadImage(NSURL(string:songList[indexPath.row].coverUrl! as String)!)
       // songList[indexPath.row].coverImage = cell.coverImg.image!
 
        return cell
    }
}