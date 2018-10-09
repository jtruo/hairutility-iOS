//
//  UserProfileController.swift
//  HairLink
//
//  Created by James Truong on 7/26/17.
//  Copyright © 2017 James Truong. All rights reserved.
//

import UIKit
import KeychainAccess
import Alamofire

class CompanyProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CompanyHeaderDelegate {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    let userDefaults = UserDefaults.standard
    
    lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCompanyData(_:)), for: .valueChanged)
       return refreshControl
    }()
    
    @objc func refreshCompanyData(_ sender: Any) {
        getCompanyInfo()
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
        
     
        collectionView?.backgroundColor = .white
        collectionView?.register(CompanyUserCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.register(CompanyHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.refreshControl = refreshControl
        
        self.navigationItem.title = "Please join a company"
        
        getCompanyInfo()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //Paginate call
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CompanyUserCell
        cell.user = users[indexPath.item]

        return cell
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompanyHeader
 
        headerView.delegate = self
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let layout = UICollectionViewFlowLayout()
        let stylistHairProfilesController = StylistHairProfilesController(collectionViewLayout: layout)
        stylistHairProfilesController.hairProfiles = users[indexPath.item].hairProfiles
        self.navigationController?.pushViewController(stylistHairProfilesController, animated: true)
   
        
    }
    
    @objc func headerTapped() {
        print("sdlsnfajnfalsf")
        let editCompanyController = EditCompanyController()
        let editNavController = UINavigationController(rootViewController: editCompanyController)
        present(editNavController, animated: true, completion: nil)
        
    }
    
 
    
    var authToken: String?
    var company: Company?
    var companyPk: String?
    var users = [User]()
    
    
    
//    Retrieves company info from API using
    func getCompanyInfo() {
        
        Keychain.getAuthToken { (authToken) in
            self.authToken = authToken
        }
        Keychain.getKeychainValue(name: "companyPk") { (companyPk) in
            self.companyPk = companyPk
        }
        
        guard let authToken = authToken else { return }
        guard let companyPk = companyPk else { return }
        print(companyPk)
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        let appendingUrl = "api/v1/companies/\(companyPk)/"
        
        print("The data request is \(appendingUrl)")
        Alamofire.DataRequest.userRequest(requestType: "GET", appendingUrl: appendingUrl, headers: headers, parameters: nil, success: { (company) in
            guard let company = company as? Company else { return }
    
            self.users.removeAll()
            
            DispatchQueue.main.async {

                company.userSet.forEach({ (user) in
                    self.users.append(user)
                })
                
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()

            }

            
            print(self.users)
     
        }) { (failure) in
            
            self.alert(message: "There was an error saving the profile")
        }
    }
    
    
}







