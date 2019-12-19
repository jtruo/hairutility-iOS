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
import Disk



protocol CreateHairProfileDelegate {
    func uploadPhotoButtonTapped()
}


/// TODO PROFILEPAGECONTROLLER, RIGHT BAR BUTTON, ISHIDDEN, DELEGATE

class CreateHairProfileController: UIViewController, UploadOptionsDelegate, ImagePickerDelegate, CreateHairProfileDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UITextViewDelegate, UIPopoverPresentationControllerDelegate , UINavigationBarDelegate {


    
    var isStylist: Bool?
    var imageArray: [UIImage] = [UIImage]()
    var s3UrlArray = [String]()
    var createProfileDelegate: ProfilePageDelegate?
   

    lazy var firstImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 4
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(button:)))
        iv.addGestureRecognizer(gestureRecognizer)
        return iv
        
    }()
    
    lazy var secondImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 4
        iv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(button:)))
        iv.addGestureRecognizer(gestureRecognizer)
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
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(button:)))
        iv.addGestureRecognizer(gestureRecognizer)
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
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(button:)))
        iv.addGestureRecognizer(gestureRecognizer)
        return iv
    }()
    
//    lazy var cameraButton: LOTAnimationView = {
//        let lotAnimationView = LOTAnimationView(name: "big_camera")
//        lotAnimationView.isUserInteractionEnabled = true
//        lotAnimationView.contentMode = UIViewContentMode.scaleAspectFill
//        lotAnimationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//        lotAnimationView.layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(button:)))
//        lotAnimationView.addGestureRecognizer(gestureRecognizer)
//        return lotAnimationView
//    }()
    
    lazy var profileDescriptionTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Add any specific info needed to make the cut such as: #2 clippers, layered, beachy, trim the crown 7 inches"
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

    @objc func imageTapped(button: UIButton) {
        
        var config = Configuration()
        config.doneButtonTitle = "Done"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.imageLimit = 4
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "left_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    @objc func backButtonPressed() {
        createProfileDelegate?.backButtonPressed()
  
    }
    
    lazy var uploadPhotoButton: UIButton = {
        
        let uploadButton = UIButton(type: .system)
        uploadButton.setImage(#imageLiteral(resourceName: "upload").withRenderingMode(.alwaysOriginal), for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadPhotoButtonTapped), for: .touchUpInside)

        return uploadButton
        
    }()
    
 
    @objc func uploadPhotoButtonTapped() {
        
        print(imageArray.count)
        
        guard imageArray.count == 5, profileDescriptionTextView.text != nil else {
            
            self.alert(message: "", title: "Please complete all four steps to save the hairstyle")
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
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isStylist = UserDefaults.standard.bool(forKey: "isStylist")
        view.backgroundColor = .white
        
        
        if let parent = self.parent as? ProfilePageController {
            parent.delegate2 = self
        }
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(button:)))
        firstImageView.addGestureRecognizer(gestureRecognizer)
        secondImageView.addGestureRecognizer(gestureRecognizer)
        thirdImageView.addGestureRecognizer(gestureRecognizer)
        fourthImageView.addGestureRecognizer(gestureRecognizer)
        
        
        view.addSubview(containerView)

    
        
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 350, height: 0))
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
        containerView.addSubview(firstImageView)
        containerView.addSubview(secondImageView)
        containerView.addSubview(thirdImageView)
        containerView.addSubview(fourthImageView)
        containerView.addSubview(profileDescriptionTextView)
        
        
        firstImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: thirdImageView.topAnchor, trailing: secondImageView.leadingAnchor, padding: .init(top: 16, left: 24, bottom: 1, right: 1), size: .init(width: 150, height: 150))
        
        
        secondImageView.anchor(top: containerView.topAnchor, leading: firstImageView.trailingAnchor, bottom: fourthImageView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 16, left: 1, bottom: 1, right: 24), size: .init(width: 150, height: 150))
        
        
        thirdImageView.anchor(top: firstImageView.bottomAnchor, leading: containerView.leadingAnchor, bottom: profileDescriptionTextView.topAnchor, trailing: fourthImageView.leadingAnchor, padding: .init(top: 1, left: 24, bottom: 16, right: 1), size: .init(width: 150, height: 150))
        

        
        fourthImageView.anchor(top: secondImageView.bottomAnchor, leading: thirdImageView.trailingAnchor, bottom: profileDescriptionTextView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 1, left: 1, bottom: 16, right: 24), size: .init(width: 150, height: 150))
        
        
        profileDescriptionTextView.anchor(top: nil, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: .init(top: 12, left: 25, bottom: 0, right: 25), size: .init(width: 150, height: 150))
        
        
        view.addSubview(backButton)
        view.addSubview(uploadPhotoButton)
    

        
        backButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, size: .init(width: 50, height: 50))
        

        
        
//        cameraButton.play(fromProgress: 0, toProgress: 0.3, withCompletion: nil)
//
        
    }
    
//    Remove before production
//    @objc func playAnimation() {
//        firstAnimationView.play(fromProgress: 0, toProgress: 1, withCompletion: nil)
//    }
    
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
    
    // TODO iCloud Picking is not working
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    
        
        let imageCount = images.count
        //
        guard imageCount == 4 else {
            
            // iCloud bug
            print("The count \(imageCount)")
            let actions = [UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)]
            view.alertUIView(message: "", title: "Please select four images", actions: actions)
            return
        }
        
        firstImageView.image = images[0]
        secondImageView.image = images[1]
        thirdImageView.image = images[2]
        fourthImageView.image = images[3]

        for (index, image) in images.enumerated() {
            imageArray.insert(image, at: index + 1)
        }
        
    
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    func uploadImagesToS3() {

        let dispatchGroup = DispatchGroup()
        
        let uuidKey = UUID().uuidString
        var finishedKey = ""
        s3UrlArray.removeAll()
        
        for (index, image) in imageArray.enumerated() {
            
            
            dispatchGroup.enter()
            
            print("Uploading image #: \(index)")
            
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = {(task, progress) in
                DispatchQueue.main.async(execute: {

//                    let progressFloat = CGFloat(progress.fractionCompleted)
                    
//                    if index == 0 {
//
//                        self.firstAnimationView.play(toProgress: progressFloat, withCompletion: { (finished) in
//                            print(finished)
//                            print("Animation is finished")
//
//                        })
//                    }
        
                })
            }
            
            var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
            completionHandler = { (task, error) -> Void in
                DispatchQueue.main.async(execute: {
                    

                    
                    
          
                    print("Completion error: \(String(describing: error))")
                 
                    
                    dispatchGroup.leave()

                  
                })
            }
            
            guard let snapshotImageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).png") else {
                print("There was an error with snapshot image url")
                return
            }
        
            
            do {
                
                if index == 0 {
                    try UIImageJPEGRepresentation(image, 0.4)?.write(to: snapshotImageURL)
                } else {
                    try UIImageJPEGRepresentation(image, 1)?.write(to: snapshotImageURL)
                }

            } catch let error {
                print(error)
            }
            
            //Thumbnails are prefixed in the /thumbnail folder
            if index == 0 {
                finishedKey =  "thumbnails/" + uuidKey + ".png"
                s3UrlArray.append(uuidKey + ".png")
            } else {
                finishedKey = "images/" + uuidKey + "-\(index).png"
                s3UrlArray.append(uuidKey + "-\(index).png")
            }

            
            let transferUtility = AWSS3TransferUtility.default()
            
         
            transferUtility.uploadFile(snapshotImageURL, bucket: "hairutility-prod", key: finishedKey, contentType: "image/png", expression: expression,
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
            print("All \(self.imageArray.count) network requests processed")
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
        
        
        
        let authToken = Keychain.getKey(name: "authToken")
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
            "thumbnail_key": s3UrlArray[0],
            "first_image_key": s3UrlArray[1],
            "second_image_key": s3UrlArray[2],
            "third_image_key": s3UrlArray[3],
            "fourth_image_key": s3UrlArray[4],
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
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api/v1/hairprofiles/", headers: headers, parameters: parameters, success: { (hairProfile) in
            
            
            guard let hairProfile = hairProfile as? HairProfile else {return }
            let accessCode = hairProfile.accessCode
        
      
            self.alert(message: "", title: "Successfully saved the profile to your account. Please give this access code to your client: \(accessCode)")
//            self.navigationController?.popViewController(animated: true)
        }) { (err) in
            print(err)
            self.alert(message: "", title: "There was an error with saving the profile")
        }
    }
    

    
    @objc func storeInDocumentsDirectory() {
        
        // Are thumbnails even necessary?
        // Need to start imagearray + 1
        guard let hairstyleName = hairstyleName else { return }
        guard let profileDescription = profileDescriptionTextView.text else { return }
        
        let date = Date()
        let creationDate = date.convertDateToString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        print(creationDate)
        
        do {
             try Disk.save(imageArray, to: .documents, as: "\(creationDate)/")
            
        } catch let err {
            print("Could not save images \(err)")
        }
        
        let pk = UUID().uuidString

        let coreHairProfile = CoreHairProfile(pk: pk, hairstyleName: hairstyleName , profileDescription: profileDescription, creationDate: creationDate)
        
        do {
//            try Disk.append(coreHairProfile, to: "corehairprofiles.json", in: .documents)
            
            try Disk.save(coreHairProfile, to: .documents, as: "CoreHairProfiles/\(pk).json")
            let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
       
                self.parent?.dismiss(animated: true, completion: nil)
            }
            self.alertWithActions(message: "", title: "The hair profile was stored successfully! Please close the window", actions: [okAction])
        } catch let err {
            print("Could not save to hair profiles \(err)")
        }
       
    }
    
    var coreProfiles = [CoreHairProfile]()
    
    @objc func retrieveHairProfiles() {
        
        do {
            let retrievedProfiles = try Disk.retrieve("CoreHairProfiles", from: .documents, as: [CoreHairProfile].self)
            
            print("These are the messages \(retrievedProfiles)")
        } catch let err {
            print(err)
        }
 
        
    }

}
