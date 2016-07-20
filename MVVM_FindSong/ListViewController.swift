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
import Kingfisher

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar : UISearchBar
    var modelView : ListVCViewModel
    weak var listDelegate : ListVCViewModelDelegate?

    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(ListViewController.dismissKeyboard))
        return recognizer
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(xibName: String) {
        self.searchBar = UISearchBar()
        self.modelView = ListVCViewModel()
        super.init(nibName: "ListViewController", bundle: nil)
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        creaSearchBar()
        self.view.backgroundColor = UIColor.lightGrayColor()
        edgesForExtendedLayout = .None
        self.modelView.listDelegate = self
        self.searchBar.delegate = self
        self.tableView.scrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 75.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: "SongCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell1")
    }
    
    func dismissKeyboard() {
        print("dismiss keyboard")
        self.searchBar.resignFirstResponder()
    }
    
    func creaSearchBar() {
        searchBar  = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Song name or artist"
        searchBar.text = ""
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
}

extension ListViewController: ListVCViewModelDelegate {

    func onDataRecieve() {
        print("TableView is reloaded")
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
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
    
    func searchBarText() -> String {
        guard let songtitle = searchBar.text else {
            print("nil song title")
            return ""
        }
        return songtitle
    }
    
    func configTableViewForData() {
        if modelView.songs.count == 0 {
            self.tableView.separatorStyle = .None
            self.tableView.scrollEnabled = false
            self.tableView.userInteractionEnabled = false
        }
        self.tableView.scrollEnabled = true
        self.tableView.userInteractionEnabled = true
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if tableView.contentOffset.y > 400  {
             print("load more ")
            tableView.scrollEnabled = false
            modelView.songs.removeAll()
            tableView.reloadData()
            self.modelView.getSongsByName(searchBarText(), limitSearch: 1)
        }
    }
}


extension ListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        let dvc  = DetailViewController(xibName: "DetailViewController", songIndex: indexPath.row)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print("row")
        if editingStyle == .Delete
        {   print("row")
            modelView.removeSongAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
}


extension ListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configTableViewForData()
        return modelView.songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as? SongCell else {
            return   UITableViewCell()
        }
        cell.configureCellForSong(modelView.songAtIndex(indexPath.row))
        return cell
    }
}

extension ListViewController {

    func configurateListVCWithModel(model: ListVCViewModel) {
        self.modelView = model
        self.modelView.listDelegate = self
    }
}