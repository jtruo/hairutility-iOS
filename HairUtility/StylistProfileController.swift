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
import AWSS3
import Lottie
import Kingfisher

class StylistProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            firstNameTextField.text = user.firstName
            lastNameTextField.text = user.lastName
            guard let profileImageString = user.profileImageUrl else { return }
            guard let profileImageUrl = URL(string: profileImageString) else { return }
            
            plusPhotoButton.kf.setImage(with: profileImageUrl, for: .normal)
        }
    }
    
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
    
    
    lazy var firstNameTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "First Name"
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    lazy var lastNameTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "Second Name"
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    lazy var phoneNumberTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "Phone Number"
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
//        tf.keyboardType = .numberPad
        return textField
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
    
    func uploadImageToS3() {
        print("Before image array")
        guard let image = plusPhotoButton.currentImage else { return }
        
        print("Image array was passed")
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                
                let progressFloat = CGFloat(progress.fractionCompleted)
                
                print(progressFloat)
                
//         Or just have refresh control runnign
//                self.firstAnimationView.play(toProgress: progressFloat, withCompletion: { (finished) in
//                    print(finished)
//                    print("Animation is finished")
//
//                })
                
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                
                print("Completion task: \(task)")
                print("Completion error: \(String(describing: error))")
                
            })
        }
        
        guard let snapshotImageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).png") else {
            print("There was an error with snapshot image url")
            return
        }
        do {
            try UIImageJPEGRepresentation(image, 1)?.write(to: snapshotImageURL)
        } catch let error {
            print(error)
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        let userDefaults = UserDefaults.standard
        guard let email = userDefaults.string(forKey: "email") else { return }
        let encodedEmail = email.replacingOccurrences(of: "@", with: "%40")
        
        let key = "images/\(encodedEmail)/\(UUID().uuidString).png"
        let fullS3Key = "https://s3.us-east-2.amazonaws.com/hairutilityimages/\(key)"
        
        self.fullS3Key = fullS3Key
        print(fullS3Key)
        transferUtility.uploadFile(snapshotImageURL, bucket: "hairutilityimages", key: key, contentType: "image/png",expression: expression,
                                   completionHandler: completionHandler).continueWith(executor: AWSExecutor.immediate(), block: {
                                    (task) -> Any? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                        
                                    }
                                    return nil;
                                   })
        
        self.updateUserProfile()

    }
    
    var fullS3Key: String?

    var authToken: String?
  
    
    fileprivate func updateUserProfile() {
        
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let phoneNumber = phoneNumberTextField.text else { return }
        guard let fullS3Key = self.fullS3Key else { return }

        let authToken = KeychainKeys.authToken
        let userPk = KeychainKeys.userPk

        let parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "phone_number": phoneNumber,
            "profile_image_url": fullS3Key
        ]
//        Need to require stylists to input all their info their first time and then use the if lets to specify parameters
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
   
        Alamofire.DataRequest.userRequest(requestType: "PATCH", appendingUrl: "api/v1/users/\(userPk)/", headers: headers, parameters: parameters, success: { (user) in

            guard let user = user as? User else { return }
            self.firstNameTextField.text = user.firstName
            self.lastNameTextField.text = user.lastName
            self.phoneNumberTextField.text = user.phoneNumber
            self.alert(message: "Updated your profile successfully")
        }) { (err) in
            print(err)
       
            self.alert(message: "", title: "Error: \(String(describing: err))")
        }
 
    }
    
}

