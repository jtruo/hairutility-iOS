//
//  SearchTableViewController.swift
//  HairLink
//
//  Created by James Truong on 7/14/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit


protocol SearchTableDelegate {
    func searchButtonTapped(gender: String, length: String, tags: [String])
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
        button.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
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
    var gender = ""
    var length = ""
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search bar clicked")
        
        switch searchBar.selectedScopeButtonIndex {
//
//        case 1: tags.append("men")
//        default: tags.append("women")
//
        case 1: gender = "men"
        default: gender = "women"
          
            
        }
        guard let searchBarText = searchBar.text else { return }
        
        tags.append(searchBarText)
        
        delegate?.searchButtonTapped(gender: gender, length: length, tags: tags)
        
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
  
    
    func setupAutoLayout() {
        
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 2, left: 4, bottom: 0, right: 0), size: .init(width: 50, height: 50))
        
    
        tableView.anchor(top: cancelButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
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
