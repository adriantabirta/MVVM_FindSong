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



class ListViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myTable: UITableView!
    
    let searchBar = UISearchBar()
    var dvc: DetailViewController
    let modelView: ListVCViewModel
    var listDelegate: ListVCViewModelDelegate?

    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(ListViewController.dismissKeyboard))
        return recognizer
    }()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(modelView: ListVCViewModel) {
        self.modelView = modelView
        let item : SongItem = SongItem()
        self.dvc = DetailViewController(song: item)
        super.init(nibName: "ListViewController", bundle: nil)
        self.view.backgroundColor = UIColor.lightGrayColor()
        edgesForExtendedLayout = .None
        
        let nib = UINib(nibName: "SongCell", bundle: nil)
        self.myTable.registerNib(nib, forCellReuseIdentifier: "Cell1")

     
        self.myTable.scrollEnabled = false
        self.searchBar.delegate = self
        self.modelView.listDelegate = self
        self.myTable.delegate = self
        self.myTable.dataSource = self
  
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        creaSearchBar()
    }
    
    func dismissKeyboard() {
        print("dismiss keyboard")
        self.searchBar.resignFirstResponder()
    }
    
    func creaSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Song name or artist"
        searchBar.text = ""
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
}

extension ListViewController: ListVCViewModelDelegate {

    func updateDataInTable() {
        print("TableView is reloaded")
        dispatch_async(dispatch_get_main_queue()) {
            self.myTable.reloadData()
        }
    }
}


extension ListViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.modelView.getSongsByName(searchBarText())
    }
    
    func searchBarText() ->String {
        guard let songtitle = searchBar.text else {
            print("nil song title")
            return ""
        }
        return songtitle
    }
    

    func scrollViewDidScroll(scrollView: UIScrollView) {
        var size = myTable.contentOffset.y
        //size += 150
        print(size)
        if myTable.contentOffset.y > 450  {
             print("load more ")
            myTable.scrollEnabled = false
            modelView.songs.removeAll()
            myTable.reloadData()
            modelView.loadMore()
        }
    }
}


extension ListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
       // print(modelView.songAtIndex(indexPath.row))
        dvc = DetailViewController(song: modelView.songAtIndex(indexPath.row))
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
            modelView.removeSongAtIndex(indexPath.row)
            self.myTable.reloadData()
        }
    }
}


extension ListViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if modelView.songs.count == 0 {
            self.myTable.separatorStyle = .None
            self.myTable.scrollEnabled = false
            self.myTable.userInteractionEnabled = false
        }
         self.myTable.scrollEnabled = true
        self.myTable.userInteractionEnabled = true
        return modelView.songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! SongCell
       
        let item = modelView.songAtIndex(indexPath.row)
        guard let imgUrl = item.coverUrl else {
            return cell
        }
        cell.coverImg.downloadImage(imgUrl)
        cell.title?.text = item.title
        cell.songAlbum?.text = item.artist
        cell.songLength?.text = item.songLength?.conevrtToTime()
        return cell
    }
}