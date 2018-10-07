//
//  SearchTableViewController.swift
//  HairLink
//
//  Created by James Truong on 7/14/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit

class SearchTableController: UIViewController, UITableViewDelegate, UISearchResultsUpdating {
    
    private let cellId = "cellId"
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Stuff")
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .lightGray
        tv.register(AutoCompleteCell.self, forCellReuseIdentifier: self.cellId)
        return tv
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = searchController.searchBar
        
        
    }
}
