//
//  HairProfileCreationController.swift
//  HairLink
//
//  Created by James Truong on 6/21/18.
//  Copyright © 2018 James Truong. All rights reserved.
//
import UIKit
import AVFoundation
import ImagePicker
import AWSS3
import Alamofire
import KeychainAccess
import Lottie
import Disk
//TODO: Change UILabel "Step 1" to rounded button or rects
// Add three other animation views.



class CreateHairProfileController: UIViewController, UploadOptionsDelegate, ImagePickerDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate {

    
    var isStylist: Bool?
    var imageArray: [UIImage]?
    var s3UrlArray = [String]()
    var delegate: ProfilePageDelegate?
   

    
    let imagePicker = ImagePickerController()
    var config = Configuration()
    public var imageAssets: [UIImage] {
        return AssetManager.resolveAssets(imagePicker.stack.assets)
        
    }
    
    lazy var hairstyleNameTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        return textField
    }()
    
    lazy var firstImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 4
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        return iv
    }()
    
    lazy var firstAnimationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name:"blueprogress")
        return animationView
    }()
    
    lazy var secondImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 4
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        return iv
    }()
    
    lazy var thirdImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 4
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        return iv
    }()
    
    lazy var fourthImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 4
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        return iv
    }()
    
    lazy var cameraButton: LOTAnimationView = {
        let lotAnimationView = LOTAnimationView(name: "big_camera")
        lotAnimationView.isUserInteractionEnabled = true
        lotAnimationView.contentMode = UIViewContentMode.scaleAspectFill
        lotAnimationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        lotAnimationView.layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTouched(button:)))
        lotAnimationView.addGestureRecognizer(gestureRecognizer)
        return lotAnimationView
    }()
    
    lazy var profileDescriptionTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Add any descriptions"
        tv.textColor = UIColor.lightGray
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 4.0
        tv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tv.font = .systemFont(ofSize: 16)
        tv.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
        return tv
    }()
    
//Imitates a large textField
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
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    @objc func buttonTouched(button: UIButton) {
        
        imagePicker.imageLimit = 4
        imagePicker.delegate = self
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "download"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
  
    }
    
    lazy var uploadPhotoButton: UIButton = {
        
        let uploadButton = UIButton(type: .system)
        uploadButton.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadPhotoButtonTapped), for: .touchUpInside)

        return uploadButton
        
    }()
    
    @objc func uploadPhotoButtonTapped() {
        
        hairstyleNameTextField.hasError = true
        
        guard imageArray?.count == 4, hairstyleNameTextField.text != nil, profileDescriptionTextView.text != nil else {
            self.alert(message: "", title: "Please complete all three steps to save the hairstyle")
            return
        }
        
        if isStylist == true {
            let customAlert = CustomAlert()
            customAlert.delegate = self
            customAlert.show(animated: true)
        } else {

            let locallyAction = UIAlertAction(title: "Locally", style: .default) { (alert) in
                self.storeInDocumentsDirectory()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let actions = [locallyAction, cancelAction]
            
            self.alertWithActions(message: "", title: "Are you sure you want to save?", actions: actions)
            
        
        }
        
    }
    
    let firstStepLabel: UILabel = {
        let label = UILabel()
        label.text = "Step 1:"
        return label
    }()
    
    let secondStepLabel: UILabel = {
        let label = UILabel()
        label.text = "Step 2:"
        return label
    }()
    
    let thirdStepLabel: UILabel = {
        let label = UILabel()
        label.text = "Step 3:"
        return label
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isStylist = UserDefaults.standard.bool(forKey: "isStylist")
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 350, height: 0)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        containerView.addSubview(firstStepLabel)
        containerView.addSubview(secondStepLabel)
        containerView.addSubview(thirdStepLabel)
        containerView.addSubview(hairstyleNameTextField)
        containerView.addSubview(firstImageView)
        containerView.addSubview(secondImageView)
        containerView.addSubview(thirdImageView)
        containerView.addSubview(fourthImageView)
        containerView.addSubview(cameraButton)
        containerView.addSubview(profileDescriptionTextView)
        
        firstStepLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: hairstyleNameTextField.leftAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 0, paddingRight: 2, width: 80, height: 40)
        
        hairstyleNameTextField.anchor(top: containerView.topAnchor, left: firstStepLabel.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 100, height: 30)
        
        firstImageView.anchor(top: hairstyleNameTextField.bottomAnchor, left: containerView.leftAnchor, bottom: thirdImageView.topAnchor, right: secondImageView.leftAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 1, paddingRight: 2, width: 150, height: 150)
    
        secondImageView.anchor(top: hairstyleNameTextField.bottomAnchor, left: firstImageView.rightAnchor, bottom: fourthImageView.topAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 1, paddingRight: 24, width: 150, height: 150)
        
        thirdImageView.anchor(top: firstImageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: fourthImageView.leftAnchor, paddingTop: 0, paddingLeft: 24, paddingBottom: 0, paddingRight: 2, width: 150, height: 150)
        
        fourthImageView.anchor(top: secondImageView.bottomAnchor, left: thirdImageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 1, paddingBottom: 0, paddingRight: 24, width: 150, height: 150)
        
        secondStepLabel.anchor(top: thirdImageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: cameraButton.leftAnchor, paddingTop: 8, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 80, height: 40)
        
        
        thirdStepLabel.anchor(top: secondStepLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 40)
        
        profileDescriptionTextView.anchor(top: thirdStepLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: 0, height: 100)
        
        firstImageView.addSubview(firstAnimationView)
        
        firstAnimationView.anchor(top: firstImageView.topAnchor, left: firstImageView.leftAnchor, bottom: firstImageView.bottomAnchor, right: firstImageView.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 50, height: 50)
        
       
        view.addSubview(dismissButton)
        view.addSubview(uploadPhotoButton)
    
        dismissButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        uploadPhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        cameraButton.play(fromProgress: 0, toProgress: 0.3, withCompletion: nil)
 
        
    }
    
//    Remove before production
    @objc func playAnimation() {
        firstAnimationView.play(fromProgress: 0, toProgress: 1, withCompletion: nil)
    }
    
    func leaveButtonTouched() {
        self.dismiss(animated: true, completion: nil)
    }

    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper is working")
        print(images.count)
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("cancel is working")
        dismiss(animated: true, completion: nil)
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        print("Done button pressed")
        print(imageAssets)
        
        let imageCount = images.count
        
        guard imageCount == 4 else {
            let actions = [UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)]
            view.alertUIView(message: "Please select four images", title: "", actions: actions)
            return
        }
        
        firstImageView.image = images[0]
        secondImageView.image = images[1]
        thirdImageView.image = images[2]
        fourthImageView.image = images[3]
        self.imageArray = images
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    func uploadImagesToS3() {
        print("Before image array")
        guard let imageArray = imageArray else { return }
        
        print("Image array was passed")
        let dispatchGroup = DispatchGroup()
        
        for (index, image) in imageArray.enumerated() {
            
            dispatchGroup.enter()
            
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
            
            let transferUtility = AWSS3TransferUtility.default()
            
            let userDefaults = UserDefaults.standard
            guard let email = userDefaults.string(forKey: "email") else { return }
            let encodedEmail = email.replacingOccurrences(of: "@", with: "%40")

            let key = "images/\(encodedEmail)/\(UUID().uuidString).png"
            let fullS3Key = "https://s3.us-east-2.amazonaws.com/hairutilityimages/\(key)"
            
            s3UrlArray.append(fullS3Key)
            print(s3UrlArray.count)
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
        
        
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) {
            print("All \(imageArray.count) network requests completed")
            self.postHairProfile()
        }
    }
    

    func uploadOptionsButtonTapped(hairLengthTag: String, genderTag: String, isPubliclyDisplayable: Bool, extraTags: [String]) {
        self.hairLengthTag = hairLengthTag
        self.genderTag = genderTag
        self.isPubliclyDisplayable = isPubliclyDisplayable

        
        //Optional extra tags
        if extraTags.isEmpty == false {
            firstExtraTag = extraTags[safe: 0]
            secondExtraTag = extraTags[safe: 1]
            thirdExtraTag = extraTags[safe: 2]
        }
        
        uploadImagesToS3()
    }
    
 
    var hairstyleName: String?
    var isPubliclyDisplayable: Bool = false
    var hairLengthTag: String?
    var genderTag: String?
    var firstExtraTag: String?
    var secondExtraTag: String?
    var thirdExtraTag: String?

    fileprivate func postHairProfile() {
        print("Posting hair profile")
        
        
        
        let authToken = KeychainKeys.authToken
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        
        guard let hairstyleName = self.hairstyleName else { return }
        guard let descriptionText = profileDescriptionTextView.text else { return }
        guard let genderTag = genderTag else { return }
        guard let hairLengthTag = hairLengthTag else { return }
        

        let parameters: [String: Any] = [
            "hairstyle_name": hairstyleName,
            "first_image_key": s3UrlArray[0],
            "second_image_key": s3UrlArray[1],
            "third_image_key": s3UrlArray[2],
            "fourth_image_key": s3UrlArray[3],
            "profile_description": descriptionText,
            "is_displayable": isPubliclyDisplayable,
            "gender": genderTag,
            "length": hairLengthTag,
            "tags": [
                firstExtraTag,
                secondExtraTag,
                thirdExtraTag
                ].compactMap { $0 }
        ]
        
        print(parameters)
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api/v1/hairprofiles/", headers: headers, parameters: parameters, success: { (hairProfiles) in

            print("finished")
            self.alert(message: "Successfully saved profiles to your account")
        }) { (err) in
            print(err)
            self.alert(message: "There was an error with saving the profile")
        }
    }
    

    
    @objc func storeInDocumentsDirectory() {
        
        
        //        Store images in folder with the date and time, and then store date and time. Retrieve images with the date with the received hair profile
        guard let hairstyleName = hairstyleNameTextField.text else { return }
        guard let profileDescription = profileDescriptionTextView.text else { return }
        guard let imageArray = imageArray else { return }
        
        let date = Date()
        let creationDate = date.convertDateToString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        print(creationDate)
        
        do {
             try Disk.save(imageArray, to: .documents, as: "\(creationDate)/")
            
        } catch let err {
            print("Could not save images \(err)")
        }

        let coreHairProfile = CoreHairProfile(hairstyleName: hairstyleName , profileDescription: profileDescription, creationDate: creationDate)
        
        do {
            try Disk.append(coreHairProfile, to: "corehairprofiles.json", in: .documents)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
                self.dismiss(animated: true, completion: nil)
            }
            self.alertWithActions(message: "", title: "The hair profile was stored successfully!", actions: [okAction])
        } catch let err {
            print("Could not append to hair profiles \(err)")
        }
       
    }
    
    var coreProfiles = [CoreHairProfile]()
    
    @objc func retrieveHairProfiles() {
        
        do {
            let retrievedMessages = try Disk.retrieve("corehairprofiles.json", from: .documents, as: [CoreHairProfile].self)
            
            print("These are the messages \(retrievedMessages)")
        } catch let err {
            print(err)
        }
 
        
    }

}
