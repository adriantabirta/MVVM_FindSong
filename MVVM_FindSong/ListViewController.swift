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
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    var modelView : ListViewModel
    weak var listDelegate : ListViewModelDelegate?

    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(ListViewController.dismissKeyboard))
        return recognizer
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.modelView = ListViewModel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        creaSearchBar()
        self.view.backgroundColor = UIColor.lightGrayColor()
        edgesForExtendedLayout = .None

        
        self.segmentedControl.tintColor =  UIColor.whiteColor() //UIColor(red: 0.9686, green: 0.9137, blue: 0.4353, alpha: 1.0)
        self.segmentedControl.layer.cornerRadius = 0.0;
        self.segmentedControl.layer.borderColor = UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1).CGColor //UIColor.whiteColor().CGColor
        self.segmentedControl.layer.backgroundColor = UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1).CGColor // UIColor.whiteColor().CGColor
        self.segmentedControl.layer.borderWidth = 1.5
        self.segmentedControl.layer.masksToBounds = true
        
        self.modelView.listDelegate = self
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
        UIApplication.sharedApplication().sendAction( #selector(UIResponder.resignFirstResponder), to:nil, from:nil, forEvent:nil)
    }

    func creaSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Song name or artist"
        searchBar.tintColor = UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
        searchBar.barTintColor = UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
        searchBar.backgroundColor = UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
        searchBar.text = ""
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    func checkIfModelHaveSongs() {
        if self.modelView.songs.count == 0 {
            self.imageView.hidden = false
            self.label.hidden = false
        } else {
            self.imageView.hidden = true
            self.label.hidden = true
        }
    }
    
    func setupInfoView() {
    
        switch self.segmentedControl.selectedSegmentIndex {
        case 0 :
            if self.modelView.songs.count == 0 {
                self.imageView.image = UIImage(named: noWebDataImageName)
                self.label.text = noWebDataString
                self.imageView.hidden = false
                self.label.hidden = false
            } else {
                self.imageView.hidden = true
                self.label.hidden = true
            }
        case 1 :
            if self.modelView.songs.count == 0 {
                self.imageView.image = UIImage(named: noLocalDataImageName)
                 self.label.text = noLocalDataString
                self.imageView.hidden = false
                self.label.hidden = false
            } else {
                self.imageView.hidden = true
                self.label.hidden = true
            }
            
        default:
            break
        }
    }
    
  
    @IBAction func segmentedButtonTap(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            print("load web data")
              modelView.getWebData()
              setupInfoView()
        case 1 :
            print("load local data")
            modelView.getLocalData()
            setupInfoView()
        default:
            print("nunu")
        }
    }
    
}

extension ListViewController: ListViewModelDelegate {

    func onDataRecieve() {
        print("TableView is reloaded")
        dispatch_async(dispatch_get_main_queue()) {
            self.setupInfoView()
            //self.checkIfModelHaveSongs()
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
        guard let some = searchBar.text else { return }
        self.modelView.getSongsByName(some)
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
            self.modelView.getSongsByName(modelView.getSearchText(), limitSearch: 1)
        }
    }
}


extension ListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.resignFirstResponder()
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let dvc  = DetailViewController.init(nibName: String(DetailViewController), bundle: NSBundle.mainBundle(), songNr: indexPath.row)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
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

    func configurateListVCWithModel(model: ListViewModel) {
        self.modelView = model
        self.modelView.listDelegate = self
    }
}