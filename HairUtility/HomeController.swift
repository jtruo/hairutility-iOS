//
//  HomeController.swift
//  HairLink
//
//  Created by James Truong on 8/2/17.
//  Copyright © 2017 James Truong. All rights reserved.
//
import UIKit
import KeychainAccess
import Alamofire
import Kingfisher
import AWSS3



class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, SearchTableDelegate  {

    
    private let cellId = "cellId"
    
    
    let onboardingLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "Swipe down to see hair profiles!"
        label.isHidden = true
        return label
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCompanyData(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc func refreshCompanyData(_ sender: Any) {
        getDisplayedHairProfiles()
    }

    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.barTintColor = .white
        return searchBar
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            guard let collectionView = self.collectionView else { return }
            collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y-self.refreshControl.frame.size.height), animated: true)
            self.refreshControl.beginRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    
        collectionView?.register(DifferentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white
        collectionView?.refreshControl = self.refreshControl
        collectionView?.showsVerticalScrollIndicator = true
        
        
        view.addSubview(onboardingLabel)
        onboardingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        onboardingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        onboardingLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: .init(width: 250, height: 50))
        
//        TODO re-implement search
//        self.navigationItem.titleView = searchBar
//        view.addSubview(searchBar)
        
        if hairProfiles.count == 0 {
            
            onboardingLabel.isHidden = false
            
        }
        
        collectionView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 4, bottom: 0, right: 4))
     
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Should present controller")
        searchBar.resignFirstResponder()
        let searchTableController = SearchTableController()
        searchTableController.delegate = self
        present(searchTableController, animated: true, completion: nil)
    }
    
    
    func searchButtonTapped(gender: String, length: String, tags: [String]) {
        

        let tagQueries = tags
        self.gender = gender
        self.length = length
        
        let formattedQuery = tagQueries.joined(separator: ",")
        searchBar.text = formattedQuery
        
        self.formattedQuery = formattedQuery
        print(formattedQuery)
        
        self.refreshControl.beginRefreshingManually()
        getDisplayedHairProfiles()
    
    }

    
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if hairProfiles.count == totalCount {
        isFinishedPaging = true
    }
    
    if indexPath.item == self.hairProfiles.count - 3 && !isFinishedPaging {
        
        offset += 21
        getDisplayedHairProfiles()
        print("Hairprofile total count = \(self.hairProfiles.count)")
        print("Total offset = \(self.offset)")
        print("Is it finished paging? \(isFinishedPaging)")
        
    }
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DifferentCell
    cell.hairProfile = hairProfiles[indexPath.item]

    //        cell.hairstyleImageView.frame = cell.contentView.frame
    
    return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hairProfiles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
        let displayHairProfileController = DisplayHairProfileController()
        displayHairProfileController.hairProfile = hairProfiles[indexPath.item]
        self.navigationController?.pushViewController(displayHairProfileController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 300)
        // width is going to be UImainscreen.bounds.view.frame.widtrh ;on the cell
        let width = (view.frame.width - 10) / 3
        print("Width: o;ifdajn;f \(width)")
        return CGSize(width: width, height: width + (width / 3))
    }
    
    
    
    var authToken: String?
    var hairProfiles = [HairProfile]()
    var offset: Int = 0
    var isFinishedPaging = false
    var totalCount: Int = 0
    var formattedQuery = String()
    var gender = String()
    var length = String()
//    icontains checks for men or women all of the time, so it just returns. Have icontains match two tags at once
    
    fileprivate func getDisplayedHairProfiles() {
        
        let authToken = Keychain.getKey(name: "authToken")
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
//        Search query is basaed on the url
//         Need to update hair profile creation screen
//        Right now, we need to make a hair profile with the gender and length tag to test if it works
//     Chnage filtering to   Icontains 2-3 letters of first words
        
        
//        Needs to select length
//        Do we want to make short, medium, and long innate?
//        Some people might not care, but it helps with filtering.
        //        Option 1: Make gender and length innate fields
        //        Option 2: Make Gender innate, but then have short, medium, and long in tags.
        //        Option 3: Chain filters
        
//        May need tags to be an arrayfield instead if postgres
        let appendingUrl = "api/v1/hairprofiles/?is_approved=True&gender=\(gender)&length=\(length)&tags=\(formattedQuery)&offset=\(offset)"
        
        Alamofire.DataRequest.userRequest(requestType: "GET", appendingUrl: appendingUrl, headers: headers, parameters: nil, success: { (apiResult) in
            guard let apiResult = apiResult as? RawApiResponse else { return }
            print("Total count is \(apiResult.count)")
            self.totalCount = apiResult.results.count
            
            if self.totalCount == 0 {
                self.alert(message: "", title: "No hair profiles were found :(")
            } else {
                self.onboardingLabel.isHidden = true
            }
            
            self.hairProfiles.removeAll()
            
            DispatchQueue.main.async {
                
                apiResult.results.forEach({ (hairprofile) in
                    self.hairProfiles.append(hairprofile)
                })
                
                self.collectionView?.showsVerticalScrollIndicator = false
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
            }

        }) { (Error) in
            print(Error)
            self.alert(message: "", title: "There was an error retrieving hair profiles")
            self.refreshControl.endRefreshing()
        }
    }
//Terminating probably because returns 0. Don't append if nothing
}




