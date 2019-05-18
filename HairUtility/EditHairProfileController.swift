//
//  EditHairProfileController.swift
//  HairLink
//
//  Created by James Truong on 6/29/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import ImagePicker
import KeychainAccess
import AWSS3
import Kingfisher
import Alamofire
import Lottie
import Lightbox
import Disk

class EditHairProfileController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageArray = [UIImage]()
    var s3UrlArray = [URL]()
    var s3KeyArray = [String]()
    var changedImageArray = [Int: UIImage]()
    
    var hairProfile: HairProfile? {
        didSet{
            
            guard let hairProfile = hairProfile else { return }
            
            let firstImageKey = hairProfile.firstImageKey
            let secondImageKey = hairProfile.secondImageKey
            let thirdImageKey = hairProfile.thirdImageKey
            let fourthImageKey = hairProfile.fourthImageKey
            let hairstyleName = hairProfile.hairstyleName
            let profileDescription = hairProfile.profileDescription
            let creatorName = hairProfile.creator
            let tags = hairProfile.tags.joined(separator: ", ")
  
            
            let firstImageUrl = prefixAndConvertToImageS3Url(suffix: firstImageKey)
            let secondImageUrl = prefixAndConvertToImageS3Url(suffix: secondImageKey)
            let thirdImageUrl = prefixAndConvertToImageS3Url(suffix: thirdImageKey)
            let fourthImageUrl = prefixAndConvertToImageS3Url(suffix: fourthImageKey)
            
        
            firstImageView.kf.setImage(with: firstImageUrl)
            secondImageView.kf.setImage(with: secondImageUrl)
            thirdImageView.kf.setImage(with: thirdImageUrl)
            fourthImageView.kf.setImage(with: fourthImageUrl)
            
            profileDescriptionTextView.text = profileDescription
            self.creatorTextView.text = creatorTextView.text + creatorName
            self.tagsTextView.text = tagsTextView.text + tags
            self.profilePk = hairProfile.pk
            self.navigationItem.title = hairstyleName
    
            s3UrlArray.append(contentsOf: [firstImageUrl, secondImageUrl, thirdImageUrl, fourthImageUrl])
            s3KeyArray.append(contentsOf: [firstImageKey, secondImageKey, thirdImageKey, fourthImageKey])
     
        }
    }
    
    var coreHairProfile: CoreHairProfile? {
        didSet {
            guard let coreHairProfile = coreHairProfile else { return }
            let directory = "\(coreHairProfile.creationDate)"
            do {
                let retrievedImages = try Disk.retrieve(directory, from: .documents, as: [UIImage].self)
                firstImageView.image = retrievedImages[1]
                secondImageView.image = retrievedImages[2]
                thirdImageView.image = retrievedImages[3]
                fourthImageView.image = retrievedImages[4]
                profileDescriptionTextView.text = coreHairProfile.profileDescription
              
                self.navigationItem.title = coreHairProfile.hairstyleName
                
                //                Do we need to retrieve all images?
                // DOes this even work? Maybe add images array optionallly
            } catch let err {
                print("Error retrieving core hair profile: \(err)")
            }
            
        }
    }
    
    

    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    lazy var firstImageView: UIImageView = {
        let iv = UIImageView()
        iv.tag = 0
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        iv.isUserInteractionEnabled = true
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        //        iv.image = #imageLiteral(resourceName: "Slice 1")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
        
    }()
    
    
    lazy var firstAnimationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name:"blueprogress")
        //        animationView.setValue(UIColor.purple, forKeyPath: "Ellipse Path 1.Fill.Color")
        return animationView
    }()
    
    lazy var secondImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.tag = 1
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 4
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        //        iv.image = #imageLiteral(resourceName: "Slice 1")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    
    lazy var thirdImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        iv.tag = 2
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    
    lazy var fourthImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        iv.tag = 3
        //        iv.image = #imageLiteral(resourceName: "Slice 1")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {

             print("Tap detected")
        
        guard let index = sender.view?.tag else { return }
        guard let firstImage = firstImageView.image else { return }
        guard let secondImage = secondImageView.image else { return }
        guard let thirdImage = thirdImageView.image else { return }
        guard let fourthImage = fourthImageView.image else { return }
        self.currentIndex = index
        
   

        
        switch editButton.titleLabel?.text {
        case "Save":
            
            imageArray = [firstImage, secondImage, thirdImage, fourthImage]
            
            
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            present(imagePickerController, animated: true, completion: nil)

        default:
            let images = [
                LightboxImage(image: firstImage),
                LightboxImage(image: secondImage),
                LightboxImage(image: thirdImage),
                LightboxImage(image: fourthImage)
            ]
            let controller = LightboxController(images: images, startIndex: index)
            present(controller, animated: true, completion: nil)
        }
    
    }
    
    var currentIndex: Int?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let indexChanged = currentIndex else { return }
        print("This is the current index \(indexChanged)")

        let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        
         changedImageArray[indexChanged] = originalImage
//        Right now, the image is uploaded %40 is different than @ in the url
        
        print("This is the changed image \(changedImageArray)")
        
        
        switch indexChanged {
        case 0:
            firstImageView.image = originalImage
        case 1:
            secondImageView.image = originalImage
        case 2:
            thirdImageView.image = originalImage
        case 3:
            fourthImageView.image = originalImage
        default:
            break

        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    lazy var profileDescriptionTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.textColor = UIColor.lightGray
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.font = .systemFont(ofSize: 16)
        tv.layer.cornerRadius = 4
        tv.delegate = self
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        self.view.addGestureRecognizer(tapRecognizer)
        
        return tv
    }()
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Add any descriptions"
//            textView.textColor = UIColor.lightGray
//        }
//    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        
    }

    let uploadPhotoButton: UIButton = {
        
        let uploadButton = UIButton(type: .system)
        uploadButton.setImage(#imageLiteral(resourceName: "upload").withRenderingMode(.alwaysOriginal), for: .normal)
        //        uploadButton.addTarget(self, action: #selector(printSomething), for: .touchUpInside)
        return uploadButton
        
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.text = "Edit"
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true 
        return button
    }()
    
    lazy var rightBarButton: UIBarButtonItem = {
        let b = UIBarButtonItem(customView: editButton)
        return b
    }()
    
    @objc func editButtonTapped() {
        
        print("Edit button tapped")
        editButton.preventRepeatedPresses()
        
        // This won't run the first time, because editbutton is never tapped
        if editButton.currentTitle == "Edit" {
//            editButton.setTitle("Save", for: .normal)
            editButton.setTitle("Save", for: .normal)
            self.profileDescriptionTextView.isEditable = true
            self.tagsTextView.isEditable = true
            self.profileDescriptionTextView.isUserInteractionEnabled = true
            
        } else {
            
            if let coreHairProfile = self.coreHairProfile {
                
                let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                    
                }
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    self.editButton.setTitle("Edit ", for: .normal)
                    
                    self.profileDescriptionTextView.isEditable = false
                    self.tagsTextView.isEditable = false
                    
                    for (index, image) in self.changedImageArray {
                        do {
                            try Disk.save(image, to: .documents, as: "\(coreHairProfile.creationDate)/\(index).png")
                        } catch let err {
                            print("This is an error with the disk \(err)")
                        }
    
                    }
            
                
                }
                let actions = [noAction, yesAction]
                self.alertWithActions(message: "", title: "Are you sure you want to save? This will overwrite your images", actions: actions)
                
             
            } else {
                let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                    
                }
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    self.editButton.setTitle("Edit", for: .normal)
                    
                    self.profileDescriptionTextView.isEditable = false
                    self.tagsTextView.isEditable = false
                    self.uploadImagesToS3()
                }
                let actions = [noAction, yesAction]
                self.alertWithActions(message: "", title: "Are you sure you want to save? This will overwrite your images", actions: actions)
                
                
            }
    
            
        }
    }
    
    lazy var creatorTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Created by: "
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    lazy var tagsTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Tags: "
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
        
    }()
    
    lazy var bottomContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        view.backgroundColor = .white
        
//        view.addSubview(containerView)
//
//        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 350, height: 0))
//        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        
//        
//        containerView.addSubview(firstImageView)
//        containerView.addSubview(secondImageView)
//        containerView.addSubview(thirdImageView)
//        containerView.addSubview(fourthImageView)
//        containerView.addSubview(profileDescriptionTextView)
//        containerView.addSubview(creatorTextView)
//        containerView.addSubview(tagsTextView)
////        containerView.addSubview(firstAnimationView)
//        
//        
//        firstImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: thirdImageView.topAnchor, trailing: secondImageView.leadingAnchor, padding: .init(top: 0, left: 6, bottom: 1, right: 1), size: .init(width: 168, height: 168))
//        
//        
//        secondImageView.anchor(top: containerView.topAnchor, leading: firstImageView.trailingAnchor, bottom: fourthImageView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 1, bottom: 1, right: 6), size: .init(width: 168, height: 168))
//        
//        
//        thirdImageView.anchor(top: firstImageView.bottomAnchor, leading: containerView.leadingAnchor, bottom: profileDescriptionTextView.topAnchor, trailing: fourthImageView.leadingAnchor, padding: .init(top: 0, left: 6, bottom: 8, right: 1), size: .init(width: 168, height: 168))
//        
//        
//        fourthImageView.anchor(top: secondImageView.bottomAnchor, leading: thirdImageView.trailingAnchor, bottom: profileDescriptionTextView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: 1, bottom: 8, right: 6), size: .init(width: 168, height: 168))
//        
//        
//        
//        profileDescriptionTextView.anchor(top: thirdImageView.bottomAnchor, leading: containerView.leadingAnchor, bottom: creatorTextView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 336, height: 89))
//        
//        creatorTextView.anchor(top: profileDescriptionTextView.bottomAnchor, leading: containerView.leadingAnchor, bottom: tagsTextView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
//        
//        tagsTextView.anchor(top: creatorTextView.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, size: .init(width: 150, height: 50))
        
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 350, height: 322))
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.addSubview(firstImageView)
        containerView.addSubview(secondImageView)
        containerView.addSubview(thirdImageView)
        containerView.addSubview(fourthImageView)
      
        
        firstImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: thirdImageView.topAnchor, trailing: secondImageView.leadingAnchor, padding: .init(top: 0, left: 14, bottom: 1, right: 1), size: .init(width: 160, height: 160))
        secondImageView.anchor(top: containerView.topAnchor, leading: firstImageView.trailingAnchor, bottom: fourthImageView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 1, bottom: 1, right: 14), size: .init(width: 160, height: 160))
        thirdImageView.anchor(top: firstImageView.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: fourthImageView.leadingAnchor, padding: .init(top: 1, left: 14, bottom: 0, right: 1), size: .init(width: 160, height: 160))
        fourthImageView.anchor(top: secondImageView.bottomAnchor, leading: thirdImageView.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 1, left: 1, bottom: 0, right: 14), size: .init(width: 160, height: 160))
        
        //bottom
        
        view.addSubview(bottomContainerView)
        bottomContainerView.anchor(top: containerView.bottomAnchor, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 320, height: 0))
        bottomContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomContainerView.addSubview(profileDescriptionTextView)
        bottomContainerView.addSubview(creatorTextView)
        bottomContainerView.addSubview(tagsTextView)
        
        profileDescriptionTextView.anchor(top: bottomContainerView.topAnchor, leading: bottomContainerView.leadingAnchor, bottom: creatorTextView.topAnchor, trailing: bottomContainerView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 100))
        
        creatorTextView.anchor(top: profileDescriptionTextView.bottomAnchor, leading: bottomContainerView.leadingAnchor, bottom: tagsTextView.topAnchor, trailing: bottomContainerView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
        
        tagsTextView.anchor(top: creatorTextView.bottomAnchor, leading: bottomContainerView.leadingAnchor, bottom: nil, trailing: bottomContainerView.trailingAnchor, size: .init(width: 0, height: 50))
        
        
//        firstImageView.addSubview(firstAnimationView)
//        firstAnimationView.anchor(top: firstImageView.topAnchor, left: firstImageView.leftAnchor, bottom: firstImageView.bottomAnchor, right: firstImageView.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 50, height: 50)
        
        print("Hieght is: \(containerView.frame.size.height)")
    
        
    }
    
    
    func leaveButtonTouched() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImagesToS3() {
        print("Before image array")

        
        print("Image array was passed")
        let dispatchGroup = DispatchGroup()
        
        
        for (index, image) in changedImageArray {
//            Separate dicitonary values
            dispatchGroup.enter()
            print("This is the image \(image)")
            
            print("Uploading image #: \(index)")
            
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = {(task, progress) in
                DispatchQueue.main.async(execute: {
                    
                    let progressFloat = CGFloat(progress.fractionCompleted)
                    
                    print(progressFloat)
                    
                    if index == 0 {
                        
                        self.firstAnimationView.play(toProgress: progressFloat, withCompletion: { (finished) in
                            print(finished)
                            print("Animation is finished")
                            
                        })
                    }
                    
                })
            }
            
            var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
            completionHandler = { (task, error) -> Void in
                DispatchQueue.main.async(execute: {
                    
                    dispatchGroup.leave()
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
            
            let key = s3KeyArray[index]
            let fullKey = key.replacingOccurrences(of: ".png", with: ".png\(index)")
    
//            updateUserProfile(newS3Key: key)
            
            let transferUtility = AWSS3TransferUtility.default()

            transferUtility.uploadFile(snapshotImageURL, bucket: "hairutility-prod", key: fullKey, contentType: "image/png",expression: expression,
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
        

        
            dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) {
                print("All \(self.changedImageArray.count) network requests completed")
                
            }
        }
    }


    var profilePk: String?
    var parameters: [String: Any] = [
        :
    ]
    
    func updateUserProfile(newS3Key: String?) {

        
        let authToken = Keychain.getKey(name: "authToken")
        guard let profilePk = profilePk else { return }
        

        if let description = profileDescriptionTextView.text {
            parameters["profile_description"] = description
        }
        
        guard let indexChanged = currentIndex else { return }
        
        if let newS3Key = newS3Key {
            switch indexChanged {
            case 0:
                parameters["first_image_key"] = newS3Key
            case 1:
                parameters["second_image_key"] = newS3Key
            case 2:
                parameters["third_image_key"] = newS3Key
            case 3:
                parameters["fourth_image_key"] = newS3Key
            default:
                break
            }
        }
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        

        Alamofire.DataRequest.userRequest(requestType: "PATCH", appendingUrl: "api/v1/hairprofiles/\(profilePk)/", headers: headers, parameters: parameters, success: { (hairProfile) in

            self.alert(message: "Updated the profile successfully")
        }) { (err) in
            print(err)
        }
        
    }
    
}

// Protocol orientired prgoramming, make the uitextview/protocols at the bottom
