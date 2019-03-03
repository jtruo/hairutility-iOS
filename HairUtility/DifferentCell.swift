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
        
        hairstyleNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: hairstyleImageView.topAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
        
        hairstyleImageView.anchor(top: hairstyleNameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 2, paddingBottom: 0, paddingRight: 2, width: 0, height: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
