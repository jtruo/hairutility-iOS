//
//  EditCompanyProfileController.swift
//  HairLink
//
//  Created by James Truong on 8/27/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess
import AWSS3
import Lottie

//Optional add a banner image or bio. When pressing next send the data to server to create company, get the company pk and send a patch of banner image and bio
//Also when users click the next save a variable that tells whether the u


class EditCompanyController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, AddStylistDelegate {


    let bannerLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "Banner Image: Preferred size 1920x1080 pixels (16:9 ratio)"
        return label
    }()
    
    
    
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
        
        
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 1
        
        dismiss(animated: true, completion: nil)
    }
    
    let bioLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "Bio"
        return label
    }()
    
    lazy var companyBioTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.lightGray
        tv.layer.borderWidth = 0.5
        tv.layer.cornerRadius = 4.0
        tv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tv.font = .systemFont(ofSize: 16)
        tv.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
        return tv
    }()
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add any descriptions"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    lazy var addInfoButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow"), for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(addInfoButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    @objc func addInfoButtonPressed() {
        
        self.uploadImageToS3()
        
    }
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add a stylist to the company", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleAddStylist), for: .touchUpInside)
        return button
        
    }()
    
    @objc func handleAddStylist() {
        
        let addStylistView = AddStylistView()
        addStylistView.delegate = self
        addStylistView.show(animated: true)
        
        
    }
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var firstAnimationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name:"check_mark")
        //        animationView.setValue(UIColor.purple, forKeyPath: "Ellipse Path 1.Fill.Color")
        return animationView
    }()
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let rightBarButton = UIBarButtonItem(customView: addInfoButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
        let leftBarButton = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = leftBarButton

        
        let stackView = UIStackView(arrangedSubviews: [bannerLabel, plusPhotoButton, bioLabel, companyBioTextView, updateButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 300, height: 500)
        //        plusPhotoButton.anchor(top: topLayoutGuide.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 00, paddingRight: 0, width: 256, height: 144)
        //
        //        view.addSubview(firstAnimationView)
        //        firstAnimationView.anchor(top: nil, left: nil, bottom: <#T##NSLayoutYAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, paddingTop: <#T##CGFloat#>, paddingLeft: <#T##CGFloat#>, paddingBottom: <#T##CGFloat#>, paddingRight: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        
        view.addSubview(addInfoButton)
        addInfoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: 4, width: 50, height: 50)
        //
        //
    }
    
    func addButtonTapped(email: String) {
        print("Etc")
        stylistEmail = email
        updateCompanyProfile()
        
    }
    
    func uploadImageToS3() {
        print("Uploading image #: \(index)")
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
                //                    print("This is the task: \(task)")
                //                    print("This is the progress:  \(progress) ")
                let progressFloat = CGFloat(progress.fractionCompleted)
                
                print(progressFloat)
                
                
                self.firstAnimationView.play(toProgress: progressFloat, withCompletion: { (finished) in
                    print(finished)
                    print("Animation is finished")
                    
                    
                })
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                
                print("Completion task: \(task)")
                print("Completion error: \(String(describing: error))")
                
                if error == nil {
                    self.updateCompanyProfile()
                }
            })
        }
        
        guard let snapshotImageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).png") else {
            print("There was an error with snapshot image url")
            return
        }
        do {
            guard let image = plusPhotoButton.imageView?.image else { return }
            try UIImageJPEGRepresentation(image, 1)?.write(to: snapshotImageURL)
        } catch let error {
            print(error)
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        let userDefaults = UserDefaults.standard
        guard let email = userDefaults.string(forKey: "email") else { return }
        
        let key = "images/\(email)/\(UUID().uuidString).png"
        
        let fullS3Key = "https://s3.us-east-2.amazonaws.com/hairutilityimages/\(key)"
        self.s3Url = fullS3Key
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
        
    }
    
    var authToken: String?
    var companyPk: String?
    var s3Url: String?
    var stylistEmail: String?
    
    fileprivate func updateCompanyProfile() {
        
        
        Keychain.getAuthToken { (authToken) in
            self.authToken = authToken
        }
        
        Keychain.getKeychainValue(name: "companyPk") { (companyPk) in
            self.companyPk = companyPk
        }
        guard let authToken = authToken else { return }
        guard let companyPk = companyPk else { return }
 
 
        var parameters = [String: Any]()
        
        if let stylistEmail = stylistEmail {
            parameters["users"] = [stylistEmail]
        }
        
        if let bio = companyBioTextView.text {
            parameters["bio"] = bio
        }
        if let s3Url = s3Url {
            parameters["banner_image_url"] = s3Url
        }

        print(parameters)
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        Alamofire.DataRequest.userRequest(requestType: "PATCH", appendingUrl: "api/v1/companies/\(companyPk)/", headers: headers, parameters: parameters, success: { (company) in
            guard let company = company as? Company else { return }
            print(company)
            
            self.alert(message: "Updated the company profile successfully")
            self.dismiss(animated: true, completion: nil)
        }) { (err) in
            print(err)
        }
        
    }
    
}
