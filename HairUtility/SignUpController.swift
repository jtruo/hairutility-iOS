//
//  ViewController.swift
//  HairLink
//
//  Created by James Truong on 7/24/17.
//  Copyright © 2017 James Truong. All rights reserved.
//  Could switch alamofire dependency to NSURLSESSION. Could create JSON decoder helper function. Could decode specific keys from User by overriding the default init

import UIKit
import Alamofire
import KeychainAccess


class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    

    var isStylist: Bool = false
    let defaults = UserDefaults.standard
    
    
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

    lazy var stylistLabel: BaseTextLabel = {
       let l = BaseTextLabel()
       l.text = "Are you a stylist?"
       return l
    }()
    
    @objc func handleTextInputChange() {
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.mainCharcoal()
            
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.mainGrey()
        }
        
    }

    
    lazy var isStylistButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleIsStylist), for: .touchUpInside)
        // Yes i am a stylist or no, rightbar button upload/save
        button.tintColor = .clear
        button.setImage(#imageLiteral(resourceName: "square").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "check_square").withRenderingMode(.alwaysOriginal), for: .selected)
        return button
    }()
    
    @objc func handleIsStylist() {
        if isStylistButton.isSelected == true {
            isStylistButton.isSelected = false
            isStylist = false
            
            print(isStylist)
            
        } else {
            isStylistButton.isSelected = true
            isStylist = true
            
            print(isStylist)
        }
        
    }
    
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.mainGrey()
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
        
    }()
    
    @objc func handleSignUp() {
        
        createUser()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sign Up"
        
        view.backgroundColor = .white
        
        setupInputFields()
        
        
    }
    
    fileprivate func setupInputFields() {
        
        
        let labelAndIsStylist = UIStackView(arrangedSubviews: [stylistLabel, isStylistButton])
        
        labelAndIsStylist.axis = .horizontal
        labelAndIsStylist.distribution = .fillProportionally
        labelAndIsStylist.spacing = 1
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, labelAndIsStylist, signUpButton])
        
        
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 40, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 200))
        
    }
    
    var user: User?
    
    fileprivate func createUser() {
    
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, email.count > 0 else { return }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "is_stylist": isStylist,
            ]
        let headers = [
            "Content-Type": "application/json"
        ]
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api/v1/users/", headers: headers, parameters: parameters, success: { (user) in
            guard let user = user as? User else { return }
            let authToken = user.authToken
            let pk = user.pk
            let isActive = user.isActive
            let isStylist = user.isStylist
            let email = user.email
            print(authToken)
 
            if isActive == true {
                
                do {
                    
                    let keychain = Keychain(service: "com.HairUtility")
                    try keychain.set(authToken, key: "authToken")
                    try keychain.set(pk, key: "userPk")
                    let defaults = UserDefaults.standard
                    defaults.set(isStylist, forKey: "isStylist")
                    defaults.set(isActive, forKey: "isActive")
                    print("Auth token, pk, and defaults were set")
                    self.defaults.set(self.isStylist, forKey: "isStylist")
                    self.defaults.setValue(email, forKeyPath: "email")
                }
                catch let error {
                    print(error)
                }
                
                guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
    
                mainTabBarController.setupViewControllers()
                 self.dismiss(animated: true, completion: nil)
                
            } else {
                print("There was an error saving information to defaults")
            }
            
        }) { (err) in
            self.alert(message: "", title: "Error: \(err)")
        }
        
        
    }
    
}


