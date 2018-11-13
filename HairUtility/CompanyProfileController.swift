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
//If no companyPk is found, go look up the company pk from user profile
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
        
        
        //        This is necessary so that any stylist that is added to a company can get the companyPk they were added to. The function makes an api call if no companyPk is stored in the keychain

        let keychain = Keychain(service: "HairUtility.com")
        keychain["companyPk"] = nil
        Keychain.getKeychainValue(name: "companyPk") { (companyPk) in
//            Return something when getting the pk fails.
            if companyPk.isEmpty {
                self.getCompanyPk()
                print("Getting company pk")
            } else {
                self.companyPk = companyPk
            }
        }
        
        print("Moved to tab 4")
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
    
    
//    Gets company pk from the users profile info
    func getCompanyPk() {
        
        Keychain.getAuthToken { (authToken) in
            self.authToken = authToken
        }

        guard let authToken = authToken else { return }

        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        let appendingUrl = "api/v1/users/"
        
        print("The data request is \(appendingUrl)")
        Alamofire.DataRequest.userRequest(requestType: "GET", appendingUrl: appendingUrl, headers: headers, parameters: nil, success: { (user) in
            guard let user = user as? User else { return }
            
            self.companyPk = user.companyPk
            
            DispatchQueue.main.async {
            
                
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
                
            }
            
            
            print(self.users)
            
        }) { (failure) in
            
            self.alert(message: "There was an error saving the profile")
        }
    }
    
//    Retrieves company info from API using the companyPk stored
//    Need to fill the bio text view and banner image -
    
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







