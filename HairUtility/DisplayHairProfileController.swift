//
//  DisplayHairProfileController.swift
//  HairLink
//
//  Created by James Truong on 6/28/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import AVFoundation
import AWSS3
import Alamofire
import KeychainAccess
import Lottie
import Lightbox

class DisplayHairProfileController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UITextViewDelegate {
    
    
    var hairProfile: HairProfile? {
        didSet{
            
            guard let hairProfile = hairProfile else { return }
            
            let firstImageUrl = prefixAndConvertToImageS3Url(suffix: hairProfile.firstImageKey)
            let secondImageUrl = prefixAndConvertToImageS3Url(suffix: hairProfile.secondImageKey)
            let thirdImageUrl = prefixAndConvertToImageS3Url(suffix: hairProfile.thirdImageKey)
            let fourthImageUrl = prefixAndConvertToImageS3Url(suffix: hairProfile.fourthImageKey)
            
            firstImageView.kf.setImage(with: firstImageUrl)
            secondImageView.kf.setImage(with: secondImageUrl)
            thirdImageView.kf.setImage(with: thirdImageUrl)
            fourthImageView.kf.setImage(with: fourthImageUrl)
            
            profileDescriptionTextView.text = hairProfile.profileDescription
            self.creatorTextView.text = creatorTextView.text + hairProfile.creator
            
            let tags = hairProfile.tags.joined(separator: ", ")
            self.tagsTextView.text = tagsTextView.text + tags
            
            self.navigationItem.title = hairProfile.hairstyleName
        }
    }
    
    

    
    
    lazy var firstImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        //        iv.image = #imageLiteral(resourceName: "Slice 1")
        iv.tag = 0
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
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        iv.tag = 1
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    
    lazy var thirdImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
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
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        iv.tag = 3
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    
    lazy var profileDescriptionTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.text = "Add any descriptions"
        tv.textColor = UIColor.lightGray
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.font = .systemFont(ofSize: 16)
        tv.delegate = self
        return tv
    }()
    
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
    
    lazy var downloadProfileButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    @objc func downloadButtonTapped() {
        saveHairProfile()
        
    }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
        
    }()
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        //        Index needs to be scope wide
        
        guard let index = sender.view?.tag else { return }
        guard let firstImage = firstImageView.image else { return }
        guard let secondImage = secondImageView.image else { return }
        guard let thirdImage = thirdImageView.image else { return }
        guard let fourthImage = fourthImageView.image else { return }
     
        

        let images = [
            LightboxImage(image: firstImage),
            LightboxImage(image: secondImage),
            LightboxImage(image: thirdImage),
            LightboxImage(image: fourthImage)
        ]
        let controller = LightboxController(images: images, startIndex: index)
        present(controller, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButton = UIBarButtonItem(customView: downloadProfileButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
      
        
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: nil, bottom: bottomLayoutGuide.topAnchor, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 350, height: 0)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        containerView.addSubview(firstImageView)
        containerView.addSubview(secondImageView)
        containerView.addSubview(thirdImageView)
        containerView.addSubview(fourthImageView)
        containerView.addSubview(profileDescriptionTextView)
        containerView.addSubview(creatorTextView)
        containerView.addSubview(tagsTextView)
        //        containerView.addSubview(firstAnimationView)
        
        
        
        firstImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: thirdImageView.topAnchor, right: secondImageView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 1, paddingRight: 1, width: 168, height: 168)
        
        secondImageView.anchor(top: containerView.topAnchor, left: firstImageView.rightAnchor, bottom: fourthImageView.topAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 1, paddingBottom: 1, paddingRight: 0, width: 168, height: 168)
        
        thirdImageView.anchor(top: firstImageView.bottomAnchor, left: containerView.leftAnchor, bottom: profileDescriptionTextView.topAnchor, right: fourthImageView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 1, width: 168, height: 168)
        
        fourthImageView.anchor(top: secondImageView.bottomAnchor, left: thirdImageView.rightAnchor, bottom: profileDescriptionTextView.topAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 1, paddingBottom: 0, paddingRight: 0, width: 168, height: 168)
        
        profileDescriptionTextView.anchor(top: thirdImageView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 336, height: 120)
        
        creatorTextView.anchor(top: profileDescriptionTextView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 150, height: 50)
        
        tagsTextView.anchor(top: creatorTextView.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 50)
        
        firstImageView.addSubview(firstAnimationView)
        firstAnimationView.anchor(top: firstImageView.topAnchor, left: firstImageView.leftAnchor, bottom: firstImageView.bottomAnchor, right: firstImageView.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 50, height: 50)
        
        
    
    }
    
    
    var authToken: String?
    
    fileprivate func saveHairProfile() {
        print("Posting hair profile")
        
        let authToken = KeychainKeys.authToken
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        // Could make a codable struct for hair profile
        
        guard let descriptionText = profileDescriptionTextView.text else { return }
        guard let hairstyleName = self.navigationItem.title else { return }
        
        let parameters: [String: String] = [
            "creator": (self.hairProfile?.creator)!,
            "hairstyle_name": hairstyleName,
            "thumbnail_key": "thumbnail_key",
            "first_image_key": (self.hairProfile?.firstImageKey)!,
            "second_image_key": (self.hairProfile?.secondImageKey)!,
            "third_image_key": (self.hairProfile?.thirdImageKey)!,
            "fourth_image_key": (self.hairProfile?.fourthImageKey)!,
            "profile_description": descriptionText,
            
        ]
        
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api/v1/hairprofiles/", headers: headers, parameters: parameters, success: { (hairProfiles) in
  
            print("finished")
            self.alert(message: "Successfully saved profile to your account")
        }) { (err) in
            print(err)
            self.alert(message: "Must be logged in to upload")
        }
    }
    
    
}
