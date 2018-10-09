//
//  UserProfilePhotoCell.swift
//  HairLink
//
//  Created by James Truong on 8/2/17.
//  Copyright © 2017 James Truong. All rights reserved.
//

import UIKit

class CompanyUserCell: UICollectionViewCell {
    
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            guard let firstName = user.firstName else { return }
            guard let lastName = user.lastName else { return }
            guard let profileImageString = user.profileImageUrl else { return}
            let profileImageUrl = URL(string: profileImageString)
            let fullName = firstName + " " + lastName
            self.profileImageView.kf.setImage(with: profileImageUrl)
            self.label.text = fullName
            print("Got to first name")
        }

    }
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Something"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(label)
        
        label.anchor(top: topAnchor, left: leftAnchor, bottom: profileImageView.topAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
        
        profileImageView.anchor(top: label.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 2, paddingBottom: 0, paddingRight: 2, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
