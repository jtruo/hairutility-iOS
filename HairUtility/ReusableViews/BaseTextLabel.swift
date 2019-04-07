//
//  BaseTextLabel.swift
//  HairLink
//
//  Created by James Truong on 8/4/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit


class BaseTextLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.boldSystemFont(ofSize: 16)
        self.tintColor = UIColor.mainCharcoal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
