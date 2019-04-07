//
//  UserProfileHeader.swift
//  HairLink
//
//  Created by James Truong on 7/26/17.
//  Copyright © 2017 James Truong. All rights reserved.
//

import UIKit



protocol CompanyHeaderDelegate {
    
    func headerTapped()
   

}

class CompanyHeader: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: CompanyHeaderDelegate?
    

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()


    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .green
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        return button
    }()

    @objc func handleEditProfile() {
        print("Execute edit profile / follow / unfollow logic...")
        delegate?.headerTapped()

    }
    
    
    lazy var bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        //        iv.image = #imageLiteral(resourceName: "Slice 1")
        return iv
    }()
    
    lazy var bioTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.text = "Add any descriptions"
        tv.textColor = UIColor.lightGray
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 4.0
        tv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tv.font = .systemFont(ofSize: 12)
        return tv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupBottomToolbar()

        addSubview(usernameLabel)
        addSubview(editProfileButton)
        addSubview(bannerImageView)
        addSubview(bioTextView)
        
        editProfileButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 2, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 34))
        
        bannerImageView.anchor(top: editProfileButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0), size: .init(width: 240, height: 135))
        
        bannerImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bannerImageView.backgroundColor = .lightGray

        bioTextView.anchor(top: bannerImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 50))
        
        bioTextView.backgroundColor = .purple
    }
    

    fileprivate func setupBottomToolbar() {

        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray

        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray

        addSubview(topDividerView)
        addSubview(bottomDividerView)
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
