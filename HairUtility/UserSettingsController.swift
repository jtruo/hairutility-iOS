//
//  UserSettingsController.swift
//  HairLink
//
//  Created by James Truong on 6/18/18.
//  Copyright © 2018 James Truong. All rights reserved.
//


import Alamofire
import UIKit
import KeychainAccess
//
// MARK :- ViewController
//
class UserSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let headerId = "headerId"
    private let cellId = "cellId"
    private let infoCellId = "infoCellId"
    private let companyCellId = "companyCellId"

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        title = "Settings"
        view.backgroundColor = .white
        view.addSubview(tableView)
        setupAutoLayout()
    }
    
    func setupAutoLayout() {

        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
 
    
}

