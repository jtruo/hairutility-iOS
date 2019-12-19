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
    
    lazy var hairstyleNameLabel: BaseTextLabel = {
        let l = BaseTextLabel()
        l.text = "Loading"
        return l
    }()

    lazy var hairstyleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 4
        
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        addSubview(hairstyleImageView)
        
        hairstyleImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
