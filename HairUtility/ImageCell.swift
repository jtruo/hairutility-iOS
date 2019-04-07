//
//  ImageCell.swift
//  HairLink
//
//  Created by James Truong on 3/17/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import Kingfisher
import Disk

class ImageCell: UICollectionViewCell {

    
    var hairProfile: HairProfile? {
        didSet {
            
            guard let hairProfile = hairProfile  else { return }
            let thumbnailUrl = prefixAndConvertToThumbnailS3Url(suffix: hairProfile.thumbnailKey)
            
            hairstyleImageView.kf.setImage(with: thumbnailUrl)
            hairstyleNameLabel.text = hairProfile.hairstyleName

            
        }
    }
    
    var coreHairProfile: CoreHairProfile? {
        didSet {
            guard let coreHairProfile = coreHairProfile else { return }
            let directory = "\(coreHairProfile.creationDate)"
            do {
                let retrievedImages = try Disk.retrieve(directory, from: .documents, as: [UIImage].self)
                hairstyleImageView.image = retrievedImages[0]
                hairstyleNameLabel.text = coreHairProfile.hairstyleName
//                Do we need to retrieve all images?
// DOes this even work? Maybe add images array optionallly
            } catch let err {
                print("Error retrieving core hair profile: \(err)")
            }
            
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
        
        hairstyleNameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 2, left: 2, bottom: 0, right: 2))
        
        hairstyleImageView.anchor(top: hairstyleNameLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 2, bottom: 0, right: 2))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
