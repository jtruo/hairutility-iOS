//
//  StylistHairProfilesController.swift
//  HairLink
//
//  Created by James Truong on 8/23/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import KeychainAccess
import Alamofire
import Kingfisher
import AWSS3



class StylistHairProfilesController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    

    
    let cellId = "cellId"
    
    var hairProfiles: [HairProfile]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white
 
        
        collectionView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.hairProfile = hairProfiles?[indexPath.item]
        
        //        cell.hairstyleImageView.frame = cell.contentView.frame
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hairProfiles = hairProfiles else {
            return 0
        }
        return hairProfiles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
        let displayHairProfileController = DisplayHairProfileController()
        displayHairProfileController.hairProfile = hairProfiles?[indexPath.item]
        self.navigationController?.pushViewController(displayHairProfileController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: view.frame.width, height: 300)
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    
    //Terminating probably because returns 0. Don't append if nothing
}



