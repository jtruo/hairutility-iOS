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
            hairstyleNameLabel.text = hairProfile.hairstyleName
            
        }
    }
    
    lazy var hairstyleNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading"
        return label
    }()
    
    lazy var hairstyleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit

        
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(hairstyleNameLabel)
        addSubview(hairstyleImageView)
        
        hairstyleNameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: hairstyleImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 2, left: 8, bottom: 2, right: 2))
        
        

        hairstyleImageView.anchor(top: hairstyleNameLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 2, bottom: 0, right: 2))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
