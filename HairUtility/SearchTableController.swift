//
//  SearchTableViewController.swift
//  HairLink
//
//  Created by James Truong on 7/14/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit


protocol SearchTableDelegate {
    func searchButtonTapped(tags: [String])
}

class SearchTableController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    
    private let cellId = "cellId"
    
    var delegate: SearchTableDelegate?

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.register(AutoCompleteCell.self, forCellReuseIdentifier: self.cellId)
        return tv
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.showsScopeBar = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["Women", "Men"]
        searchController.searchBar.delegate = self
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100)
        return searchController
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        setupAutoLayout()
    }
    
    
    var tags = [String]()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search bar clicked")
        
        switch searchBar.selectedScopeButtonIndex {
            
        case 1: tags.append("men")
        default: tags.append("women")
            
        }
        guard let searchBarText = searchBar.text else { return }
        
        tags.append(searchBarText)
        
        delegate?.searchButtonTapped(tags: tags)
        
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
  
    
    func setupAutoLayout() {
        
        cancelButton.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        tableView.anchor(top: cancelButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = searchController.searchBar
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AutoCompleteCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Stuff")
    }
    
}
