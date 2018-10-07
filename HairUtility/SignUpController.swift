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
    
    
    let keychain = Keychain(service: "com.HairLinkCustom.HairLink")
    var isStylist: Bool = false
    let defaults = UserDefaults.standard
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "photoButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        
        return button
        
        
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 1
        
        dismiss(animated: true, completion: nil)
    }
    
    
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
            
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }

    
    lazy var isStylistButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleIsStylist), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "like_selected"), for: .selected)
        return button
    }()
    
    @objc func handleIsStylist() {
        if isStylistButton.isSelected == true {
            isStylistButton.isSelected = false
            isStylist = false
            
        } else {
            isStylistButton.isSelected = true
            isStylist = true
        }
        
    }
    
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
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
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: topLayoutGuide.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom:0, paddingRight: 0, width: 140, height: 140)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        setupInputFields()
        
        
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, isStylistButton, signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 250)
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
                    try self.keychain.set(authToken, key: "authToken")
                    try self.keychain.set(pk, key: "pk")
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


