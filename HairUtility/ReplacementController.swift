//
//  ReplacementController.swift
//  HairLink
//
//  Created by James Truong on 8/26/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess

class ReplacementController: UICollectionViewController, UICollectionViewDelegateFlowLayout, GetHairstyleDelegate {
    
    
    private let cellId = "cellId"
    var isStylist: Bool?
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCompanyData(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc func refreshCompanyData(_ sender: Any) {
        getUserHairProfiles()
    }
    
    lazy var addProfileButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow"), for: .normal)
        button.addTarget(self, action: #selector(addProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func addProfileButtonTapped() {
        
        if isStylist == false {
            
                let getHairstyleView = GetHairstyleView()
                getHairstyleView.delegate = self
                getHairstyleView.show(animated: true)
    
        } else {
            
            let hairProfileCreationController = CreateHairProfileController()
    
            self.navigationController?.present(hairProfileCreationController, animated: true)
        }
        
    }
    
    
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
        let rightNavBarButton = UIBarButtonItem(customView: addProfileButton)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        
        

        self.isStylist = UserDefaults.standard.bool(forKey: "isStylist")
        
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white
        collectionView?.refreshControl = self.refreshControl
        
        collectionView?.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        title = "Profiles"
        view.backgroundColor = .white

        
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.hairProfile = hairProfiles[indexPath.item]
        
        //        cell.hairstyleImageView.frame = cell.contentView.frame
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hairProfiles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
        let editHairProfileController = EditHairProfileController()
        editHairProfileController.hairProfile = hairProfiles[indexPath.item]
        self.navigationController?.pushViewController(editHairProfileController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: view.frame.width, height: 300)
        let width = (view.frame.width - 1) / 2
        return CGSize(width: width, height: width)
    }
    

    func downloadButtonTapped(appendingUrl: String) {
        self.appendingUrl = appendingUrl
        getUserHairProfiles()
    }
    
    
    var authToken: String?
    var totalCount: Int = 0
    var hairProfiles = [HairProfile]()
    var appendingUrl = "api/v1/hairprofiles/?user"
    var hairProfileToDownload: HairProfile?
    
    func getUserHairProfiles() {
        
        Keychain.getAuthToken { (authToken) in
            self.authToken = authToken
        }
        
        guard let authToken = authToken else { return }
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        print("The data request is \(appendingUrl)")
        Alamofire.DataRequest.userRequest(requestType: "GET", appendingUrl: appendingUrl, headers: headers, parameters: nil, success: { (apiResult) in
            guard let apiResult = apiResult as? RawApiResponse else { return }
            self.totalCount = apiResult.results.count
            print(apiResult.results.count)
    
            
            print(self.appendingUrl)
            self.hairProfiles.removeAll()

            
            if self.appendingUrl != "api/v1/hairprofiles/?user" {
                self.hairProfileToDownload = apiResult.results[0]
                self.downloadHairProfile()
            }
            
            
            DispatchQueue.main.async {
                
                apiResult.results.forEach({ (hairprofile) in
                    self.hairProfiles.append(hairprofile)
                })
                
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
            }
           
            
        }) { (Error) in
            print(Error)
            self.alert(message: "There was an error retrieving the profiles")
        }
    }
    
    
    func downloadHairProfile() {
        print("Posting hair profile")
        
        guard let authToken = authToken else { return }
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        guard let hairProfileToSave = hairProfileToDownload else { return }
        
        print("Hairprofile to save was passed")
        
        let parameters: [String: Any] = [
            "creator": hairProfileToSave.creator,
            "hairstyle_name": hairProfileToSave.hairstyleName,
            "first_image_url": hairProfileToSave.firstImageUrl,
            "second_image_url": hairProfileToSave.secondImageUrl,
            "third_image_url": hairProfileToSave.thirdImageUrl,
            "fourth_image_url": hairProfileToSave.fourthImageUrl,
            "profile_description": hairProfileToSave.profileDescription,
            "is_displayable": false,
            ]
        
        print(parameters)
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api/v1/hairprofiles/", headers: headers, parameters: parameters, success: { (hairProfiles) in
            
            print("finished")
            self.alert(message: "Successfully saved profiles to your account")
        }) { (err) in
            print(err)
            self.alert(message: "There was an error with saving the profile")
        }
    }
    
}
