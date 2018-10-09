//
//  PersonalProfileCell.swift
//  HairLink
//
//  Created by James Truong on 6/21/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import Kingfisher

class PersonalProfileCell: UITableViewCell {
    
    
    var hairProfile: HairProfile? {
        didSet{
            guard let firstProfileImageString = hairProfile?.firstImageUrl else { return }
            let firstImageUrl = URL(string: firstProfileImageString)
            photoImageView.kf.setImage(with: firstImageUrl)
        }
    }
    
    lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 40, width: 75, height: 75)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

