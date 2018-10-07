//
//  LoginController.swift
//  HairLink
//
//  Created by James Truong on 7/30/17.
//  Copyright © 2017 James Truong. All rights reserved.
//Might not need pr. Parse json in separate controllers/files

import UIKit
import Alamofire
import KeychainAccess




class LoginController: UIViewController {
    
    var user: User?
    let keychain = Keychain(service: "com.HairLinkCustom.HairLink")
    
    lazy var emailTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "Email"
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()

    
    lazy var passwordTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLoginTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
        
    }()
    
    @objc func handleLoginTapped() {
        
        postUserCredentials()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Log In"
        
        view.backgroundColor = .white
        
        
        setupInputFields()
        
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
    }
    
    
    fileprivate func postUserCredentials() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
//        Username is the email
        let parameters = [
            "username": email,
            "password": password
        ]
        let headers = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api-token-auth/", headers: headers, parameters: parameters, success: { (user) in
            guard let user = user as? User else { return }
            
            let authToken = user.authToken
            let pk = user.pk
            let email = user.email
      
            let isActive = user.isActive
            let isStylist = user.isStylist

            if isActive == true {
                
                do {
                    try self.keychain.set(authToken, key: "authToken")
                    try self.keychain.set(pk, key: "pk")
                    let defaults = UserDefaults.standard
                    defaults.set(isStylist, forKey: "isStylist")
                    defaults.set(isActive, forKey: "isActive")
                    print("Keychain and user defaults data was set")
                    defaults.setValue(email, forKeyPath: "email")
                }
                catch let error {
                    print(error)
                }
            
                guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                mainTabBarController.setupViewControllers()
                self.dismiss(animated: true, completion: nil)
                
            } else {
                print("User is not active")
                
            }
            
        }) { (err) in
            print(err)
        }
        
    }
    
}
