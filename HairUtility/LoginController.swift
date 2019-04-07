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
            loginButton.backgroundColor = UIColor.mainCharcoal()
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.mainGrey()
        }
    }
    
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.mainGrey()
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
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        view.addSubview(stackView)

        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 40, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 150))
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
            "Content-Type": "application/json",

        ]
        
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api-token-auth/", headers: headers, parameters: parameters, success: { (user) in
            guard let user = user as? User else { return }
            
            let authToken = user.authToken
            let pk = user.pk
            let email = user.email
      
            let isActive = user.isActive
            let isStylist = user.isStylist

            
            print("This is the user pk \(pk)")
            
            if isActive == true {
                
                do {
                    let keychain = Keychain(service: "com.HairUtility")
                    try keychain.set(authToken, key: "authToken")
                    try keychain.set(pk, key: "userPk")
                    
                    let defaults = UserDefaults.standard
                    defaults.set(isStylist, forKey: "isStylist")
                    defaults.set(isActive, forKey: "isActive")
                    defaults.setValue(email, forKeyPath: "email")
                    
                    print("Keychain and user defaults data was set")
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
