//
//  ListViewController.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/8/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  AppleSongSearch {

    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myTable: UITableView!
    
    
    var songList: Array<Song>  = []
    
   // private let templateCell: UITableViewCell
    
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
        
        //print(searchSongByTitle("Carlas Dreams"))
        songList  = searchSongByTitle("Carlas Dreams")
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: Table View Methods
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
        cell.price?.text =  String(format: "%0.2f $", songList[indexPath.row].price) 
        
        print(songList[indexPath.row].title)
  
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dvc: DetailViewController
       // dvc = DetailViewController(title: songList[indexPath.row].title, album: songList[indexPath.row].album, price: String(format: "%0.2f $", songList[indexPath.row].price))
        dvc = DetailViewController(song: songList[indexPath.row])
        
        //
//        dvc.titleLbl?.text = songList[indexPath.row].title
//        dvc.albumLbl?.text = songList[indexPath.row].album
//        dvc.priceLbl?.text =  String(format: "%0.2f $", songList[indexPath.row].price)
//        dvc.some = "===> dadadada"

        self.navigationController?.pushViewController(dvc, animated: true)

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    
    
  
    
}