//
//  UserSettingsController.swift
//  HairLink
//
//  Created by James Truong on 6/18/18.
//  Copyright © 2018 James Truong. All rights reserved.
//



import UIKit
import KeychainAccess
import Alamofire


class UserSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let headerId = "headerId"
    private let cellId = "cellId"
    private let infoCellId = "infoCellId"
    private let companyCellId = "companyCellId"

    var profileImageUrl: URL?
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
//            Reloads user info cell when data is updated
            guard let profileImageString = user.profileImageUrl else { return }
            guard let profileImageUrl = URL(string: profileImageString) else { return }
            self.profileImageUrl = profileImageUrl
            
        
            let indexPath = IndexPath(item: 0, section: 0)
            tableView.reloadRows(at: [indexPath], with: .fade)
            
            
        }
    }
    
    lazy var tableView: UITableView = {

        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .lightGray


        tv.register(UserSettingsCell.self, forCellReuseIdentifier: self.cellId)
        tv.register(UserInfoCell.self, forCellReuseIdentifier: self.infoCellId)
        tv.register(CompanySettingsCell.self, forCellReuseIdentifier: self.companyCellId)
        return tv
    }()
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 150
            
        }
        
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCellId, for: indexPath) as? UserInfoCell
//             Wait for users info to load. If it fails, then put Try refreshing
            if let user = self.user {
                
        
                cell?.firstAndLastNameLabel.text = user.firstName
                cell?.phoneNumberLabel.text = user.phoneNumber
                cell?.profileImageView.kf.setImage(with: profileImageUrl)
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                }
                
            }
            
            return cell!
        
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: companyCellId, for: indexPath) as? CompanySettingsCell
            return cell!
        
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserSettingsCell
            cell?.cellTitleLabel.text = "Log out"
            return cell!
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserSettingsCell
            cell?.cellTitleLabel.text = "App Settings"
            return cell!
            
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let stylistProfileController = StylistProfileController()
            stylistProfileController.user = self.user
            
            self.navigationController?.pushViewController(stylistProfileController, animated: true)
        case 1:
            let companyController = CompanyController()
            self.navigationController?.pushViewController(companyController, animated: true)
        case 2:
            let keychain = Keychain(service: "com.HairLinkCustom.HairLink")
            keychain["authToken"] = nil
            
            DispatchQueue.main.async {
                
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                
                let onboardingController = OnboardingController(collectionViewLayout: layout)
                let navController = UINavigationController(rootViewController: onboardingController)
                self.present(navController, animated: true, completion: nil)
            }
            
        default:
            ()
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y-self.refreshControl.frame.size.height), animated: true)
            self.refreshControl.beginRefreshing()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = self.refreshControl
        title = "Settings"
        view.backgroundColor = .white
        view.addSubview(tableView)
        setupAutoLayout()
        getUserInfo()
    }
    
    func setupAutoLayout() {

        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshUserInfo(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc func refreshUserInfo(_ sender: Any) {
        getUserInfo()
    }
    
    var authToken: String?
    var pk: String?

    
    func getUserInfo() {
        
        Keychain.getAuthToken { (authToken) in
            self.authToken = authToken
        }
        Keychain.getKeychainValue(name: "pk") { (pk) in
            self.pk = pk
        }
        
        guard let authToken = authToken else { return }
        guard let pk = pk else { return }
        
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        let appendingUrl = "api/v1/users/\(pk)/"
        
        print("The data request is \(appendingUrl)")
        Alamofire.DataRequest.userRequest(requestType: "GET", appendingUrl: appendingUrl, headers: headers, parameters: nil, success: { (user) in
            guard let user = user as? User else { return }
            guard let firstName = user.firstName else { return }
            self.user = user
     
            
            
            if firstName.isEmpty {
                print("Please set up your profile")
            }
       
            DispatchQueue.main.async {
        
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }

        }) { (failure) in
            
            self.alert(message: "There was an error saving the profile")
        }
    }
 
    
}

