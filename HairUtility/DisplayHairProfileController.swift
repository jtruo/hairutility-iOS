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
        iv.layer.cornerRadius = 4
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
        iv.layer.cornerRadius = 4
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
        iv.layer.cornerRadius = 4
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
        iv.layer.cornerRadius = 4
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv.addGestureRecognizer(tapGestureRecognizer)
        return iv
    }()
    
    lazy var profileDescriptionTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.textColor = UIColor.lightGray
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.font = .systemFont(ofSize: 16)
        tv.delegate = self
        tv.layer.cornerRadius = 4
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
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
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

        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 350, height: 0))
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        containerView.addSubview(firstImageView)
        containerView.addSubview(secondImageView)
        containerView.addSubview(thirdImageView)
        containerView.addSubview(fourthImageView)
        containerView.addSubview(profileDescriptionTextView)
        containerView.addSubview(creatorTextView)
        containerView.addSubview(tagsTextView)
        //        containerView.addSubview(firstAnimationView)
        
        
        
        firstImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: thirdImageView.topAnchor, trailing: secondImageView.leadingAnchor, padding: .init(top: 16, left: 6, bottom: 1, right: 1), size: .init(width: 168, height: 168))
        
        
        secondImageView.anchor(top: containerView.topAnchor, leading: firstImageView.trailingAnchor, bottom: fourthImageView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 16, left: 1, bottom: 1, right: 6), size: .init(width: 168, height: 168))
        
        
        thirdImageView.anchor(top: firstImageView.bottomAnchor, leading: containerView.leadingAnchor, bottom: profileDescriptionTextView.topAnchor, trailing: fourthImageView.leadingAnchor, padding: .init(top: 0, left: 6, bottom: 16, right: 1), size: .init(width: 168, height: 168))
        
        
        fourthImageView.anchor(top: secondImageView.bottomAnchor, leading: thirdImageView.trailingAnchor, bottom: profileDescriptionTextView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 1, bottom: 16, right: 6), size: .init(width: 168, height: 168))
        
        
        profileDescriptionTextView.anchor(top: nil, leading: containerView.leadingAnchor, bottom: creatorTextView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: 7, bottom: 0, right: 7), size: .init(width: 336, height: 89))
        
        creatorTextView.anchor(top: profileDescriptionTextView.bottomAnchor, leading: containerView.leadingAnchor, bottom: tagsTextView.topAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        
        tagsTextView.anchor(top: creatorTextView.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, size: .init(width: 150, height: 50))
        
//        firstImageView.addSubview(firstAnimationView)
//        firstAnimationView.anchor(top: firstImageView.topAnchor, left: firstImageView.leftAnchor, bottom: firstImageView.bottomAnchor, right: firstImageView.rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 50, height: 50)
//
//
//
    }
    
    
    var authToken: String?
    
    fileprivate func saveHairProfile() {
        print("Posting hair profile")
        
        let authToken = Keychain.getKey(name: "authToken")
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        // Could make a codable struct for hair profile
        
        guard let descriptionText = profileDescriptionTextView.text else { return }
        guard let hairstyleName = self.navigationItem.title else { return }
        
        let parameters: [String: Any] = [
            "creator": (self.hairProfile?.creator)!,
            "hairstyle_name": hairstyleName,
            "thumbnail_key": (self.hairProfile?.thumbnailKey)!,
            "first_image_key": (self.hairProfile?.firstImageKey)!,
            "second_image_key": (self.hairProfile?.secondImageKey)!,
            "third_image_key": (self.hairProfile?.thirdImageKey)!,
            "fourth_image_key": (self.hairProfile?.fourthImageKey)!,
            "profile_description": descriptionText,
            "tags": (self.hairProfile?.tags)!
            
        ]
        
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api/v1/hairprofiles/", headers: headers, parameters: parameters, success: { (hairProfiles) in
  
            print("finished")
            self.alert(message: "Successfully saved profile to your account!")
            self.downloadProfileButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
    
            //TODO don't enable client to download same profile
        }) { (err) in
            print(err)
            self.alert(message: "There was an error saving the profile")
        }
    }
    
    
}
