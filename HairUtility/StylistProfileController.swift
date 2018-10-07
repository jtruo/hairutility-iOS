//
//  StylistProfileFormController.swift
//  HairLink
//
//  Created by James Truong on 6/18/18.
//  Copyright © 2018 James Truong. All rights reserved.
//
import UIKit
import Alamofire
import KeychainAccess

class StylistProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
    
    
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
        
    }()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
        
    }()
    
    var phoneNumberTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone number"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
//        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
        
    }()
    
    @objc func handleTextInputChange() {
        
        let isFormValid = firstNameTextField.text?.count ?? 0 > 0 || lastNameTextField.text?.count ?? 0 > 0 || passwordTextfield.text?.count ?? 0 > 0
        
        if isFormValid {
            
            updateButton.isEnabled = true
            updateButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            
        } else {
            updateButton.isEnabled = false
            updateButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    let passwordTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
        
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        
        return button
        
    }()
    
    @objc func handleSignUp() {
      
        updateUserProfile()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Profile"
        
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: topLayoutGuide.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom:0, paddingRight: 0, width: 140, height: 140)
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, phoneNumberTextField, updateButton])
        
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 250)
    }
    
    var user: User?
    var authToken: String?
    var pk: String?
    
    fileprivate func updateUserProfile() {
        
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let phoneNumber = phoneNumberTextField.text else { return }

        Keychain.getAuthToken { (authToken) in
            self.authToken = authToken
        }
        Keychain.getPk { (pk) in
            self.pk = pk
        }
        guard let authToken = authToken else { return }
        guard let pk = pk else { return }
        
        let parameters = [
            "first_naassaasdasdme": "dfafafasf",
//            "last_name": lastName,
//            "phone_number": phoneNumber,
//            "dsfad": "adfasdf"
        ]
//        Need to require stylists to input all their info their first time and then use the if lets to specify parameters
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
   
        Alamofire.DataRequest.userRequest(requestType: "PATCH", appendingUrl: "api/v1/users/\(pk)/", headers: headers, parameters: parameters, success: { (user) in

            guard let user = user as? User else { return }
            self.firstNameTextField.text = user.firstName
            self.lastNameTextField.text = user.lastName
            self.phoneNumberTextField.text = user.phoneNumber
            self.alert(message: "Updated your profile successfully")
        }) { (err) in
            print(err)
            let string = err as? String
            self.alert(message: "", title: "Error: \(String(describing: string))")
        }
 
    }
    
}

