//
//  DifferentCell.swift
//  HairLink
//
//  Created by James Truong on 8/30/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import Foundation


import UIKit
import Kingfisher

class DifferentCell: UICollectionViewCell {

    
    var hairProfile: HairProfile? {
        didSet {
            guard let hairProfile = hairProfile  else { return }
            let thumbnailUrl = prefixAndConvertToThumbnailS3Url(suffix: hairProfile.thumbnailKey)
            

            hairstyleImageView.kf.setImage(with: thumbnailUrl)
            
            
            print(thumbnailUrl)
            hairstyleNameLabel.text = hairProfile.hairstyleName
            tagsLabel.text = "Tags: \(hairProfile.tags.joined(separator: ", "))"
          
            
        }
    }

    
    lazy var hairstyleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 4

        return iv
    }()
    
    lazy var hairstyleNameLabel: BaseTextLabel = {
        let l = BaseTextLabel()
        l.font = UIFont.boldSystemFont(ofSize: 16)
        return l
    }()
    
    lazy var tagsLabel: BaseTextLabel = {
        let l = BaseTextLabel()
        l.font = UIFont.boldSystemFont(ofSize: 12)
        return l
    }()
    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        
        let stackView = UIStackView(arrangedSubviews: [hairstyleImageView, hairstyleNameLabel, tagsLabel])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        
        addSubview(stackView)
        
        

        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 2, bottom: 0, right: 2))
        
        hairstyleImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 3 / 4).isActive = true
        hairstyleNameLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1 / 8).isActive = true
        tagsLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1 / 8).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
