//
//  SecondPageController.swift
//  HairLink
//
//  Created by James Truong on 8/5/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess
import AWSS3
import Lottie

//Optional add a banner image or bio. When pressing next send the data to server to create company, get the company pk and send a patch of banner image and bio
//Also when users click the next save a variable that tells whether the u


class SecondPageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    lazy var bannerText: UITextView = {
        let textView = UITextView()
        textView.text = "Your company has been successfully created! (Optional) Add a banner image for your company"
        textView.isEditable = false
        textView.textColor = UIColor.lightGray
        textView.layer.borderWidth = 0.5
        textView.font = .systemFont(ofSize: 16)
        textView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        return textView
    }()
    
    let bannerLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "Banner Image: Preferred size 1920x1080 pixels (16:9 ratio)"
        return label
    }()
    

    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "placeholder_image").withRenderingMode(.alwaysOriginal), for: .normal)
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
        tv.text = "Put information you believe that sets your salon apart from others or what you specialize in."
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
        button.setImage(#imageLiteral(resourceName: "download").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(addInfoButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    @objc func addInfoButtonPressed() {
        
        self.uploadImageToS3()
        
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
        
        
        let stackView = UIStackView(arrangedSubviews: [bannerText, bannerLabel, plusPhotoButton, bioLabel, companyBioTextView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        view.addSubview(stackView)

        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 16, bottom: 0, right: 0), size: .init(width: 300, height: 500))
//        plusPhotoButton.anchor(top: topLayoutGuide.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 00, paddingRight: 0, width: 256, height: 144)
//
//        view.addSubview(firstAnimationView)

        
        view.addSubview(addInfoButton)
        
        addInfoButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 4, right: 4), size: .init(width: 50, height: 50))
//
//
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
    

    var s3Url: String?
    
    fileprivate func updateCompanyProfile() {
        
        
        let authToken = Keychain.getKey(name: "authToken")
        let companyPk = Keychain.getKey(name: "companyPk")
        
        guard let bio = companyBioTextView.text else { return }
        
        let parameters = [
            "bio": bio
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        Alamofire.DataRequest.userRequest(requestType: "PATCH", appendingUrl: "api/v1/companies/\(companyPk)/", headers: headers, parameters: parameters, success: { (company) in
            guard let company = company as? Company else { return }
            print(company)

            self.alert(message: "Updated your profile successfully")
            self.dismiss(animated: true, completion: nil)
        }) { (err) in
            print(err)
        }
        
    }
    
}
