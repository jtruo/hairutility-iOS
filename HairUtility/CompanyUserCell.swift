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
        
    
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: profileImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 2, left: 2, bottom: 2, right: 2))
    
        
        profileImageView.anchor(top: label.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 2, bottom: 0, right: 2))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
