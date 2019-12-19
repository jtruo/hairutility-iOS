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
import Kingfisher

class StylistProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            firstNameTextField.text = user.firstName
            lastNameTextField.text = user.lastName
            phoneNumberTextField.text = user.phoneNumber
            guard let profileImageString = user.profileImageUrl else { return }
            guard let profileImageUrl = URL(string: profileImageString) else { return }
            

            plusPhotoButton.layer.masksToBounds = true
            plusPhotoButton.clipsToBounds = true
            plusPhotoButton.layer.borderColor = UIColor.black.cgColor
            plusPhotoButton.layer.borderWidth = 1
            
            plusPhotoButton.kf.setImage(with: profileImageUrl, for: .normal)
        }
    }
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "placeholder_oval").withRenderingMode(.alwaysOriginal), for: .normal)
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
        textField.placeholder = "Last Name"
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
            updateButton.backgroundColor = UIColor.mainCharcoal()
            
        } else {
            updateButton.isEnabled = false
            updateButton.backgroundColor = UIColor.mainGrey()
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
        button.backgroundColor = UIColor.mainGrey()
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        
        return button
        
    }()
    
    @objc func handleSignUp() {
        
      
        if plusPhotoButton.isEqual(UIImage(named: "placeholder_oval")) {
            updateUserProfile()
        } else {
            uploadImageToS3()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Update Profile"
        
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)

        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 150))
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, phoneNumberTextField, updateButton])
        
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 250))
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
        

        let key = "profile-images/" + UUID().uuidString + ".png"
        // Can't leak emails
        let fullS3Key = "https://s3.us-east-2.amazonaws.com/hairutility-prod/\(key)"
        
        self.fullS3Key = fullS3Key
        print(fullS3Key)
        transferUtility.uploadFile(snapshotImageURL, bucket: "hairutility-prod", key: key, contentType: "image/png",expression: expression,
                                   completionHandler: completionHandler).continueWith(executor: AWSExecutor.immediate(), block: {
                                    (task) -> Any? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                        
                                        self.alert(message: "", title: "There was an error storing your profile image")
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
        
       var parameters = [String: Any]()
        
        if let firstName = firstNameTextField.text {
            parameters["first_name"] = firstName
        }
        if let lastName = lastNameTextField.text {
            parameters["last_name"] = lastName
        }
        if let phoneNumber = phoneNumberTextField.text {
            parameters["phone_number"] = phoneNumber
        }
        

        
        
        
        if let fullS3Key = self.fullS3Key {
            parameters["profile_image_url"] = fullS3Key
        }
 
        let authToken = Keychain.getKey(name: "authToken")
        let userPk = Keychain.getKey(name: "userPk")


//        Need to require stylists to input all their info their first time
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
   
        Alamofire.DataRequest.userRequest(requestType: "PATCH", appendingUrl: "api/v1/users/\(userPk)/", headers: headers, parameters: parameters, success: { (user) in

            guard let user = user as? User else { return }
            self.firstNameTextField.text = user.firstName
            self.lastNameTextField.text = user.lastName
            self.phoneNumberTextField.text = user.phoneNumber
            self.alert(message: "", title: "Updated your profile successfully")
        }) { (err) in
            print(err)
       
            self.alert(message: "", title: "Error: \(String(describing: err))")
        }
 
    }
    
}

