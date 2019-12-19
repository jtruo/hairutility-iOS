//
//  CompanyController.swift
//  HairLink
//
//  Created by James Truong on 8/3/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess

class CompanyController: UIViewController, UINavigationControllerDelegate {
    
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.backgroundColor = UIColor.mainCharcoal()
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = true
        return button
        
    }()
    
    @objc func handleSignUp() {
        
//        updateUserProfile()
        
        let companyPageController = CompanyPageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        let companyPageNavController = UINavigationController(rootViewController: companyPageController)
        present(companyPageNavController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Company"
        
        view.backgroundColor = .white
//        updateButton.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        view.addSubview(updateButton)

        updateButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 4, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
      
        updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
        
        setupInputFields()
        
    }
    
    fileprivate func setupInputFields() {
    
    }
    

//    fileprivate func updateUserProfile() {
//
//        guard let firstName = firstNameTextField.text else { return }
//        guard let lastName = lastNameTextField.text else { return }
//        guard let phoneNumber = phoneNumberTextField.text else { return }
//
//        Keychain.getAuthToken { (authToken) in
//            self.authToken = authToken
//        }
//        Keychain.getPk { (pk) in
//            self.pk = pk
//        }
//        guard let authToken = authToken else { return }
//        guard let pk = pk else { return }
//
//        let parameters = [
//            "first_name": firstName,
//            "last_name": lastName,
//            "phone_number": phoneNumber
//        ]
//
//        let headers = [
//            "Content-Type": "application/json",
//            "Authorization": "Token \(authToken)"
//        ]
//
//        Alamofire.DataRequest.userRequest(requestType: "PATCH", appendingUrl: "api/v1/users/\(pk)/", headers: headers, parameters: parameters, success: { (user) in
//            guard let user = user as? User else { return }
//            self.firstNameTextField.text = user.firstName
//            self.lastNameTextField.text = user.lastName
//            self.phoneNumberTextField.text = user.phoneNumber
//            self.alert(message: "Updated your profile successfully")
//        }) { (err) in
//            print(err)
//        }
//
//    }
    
}
