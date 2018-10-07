//
//  UserSettingsCell.swift
//  HairLink
//
//  Created by James Truong on 6/18/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit

class UserSettingsCell: UITableViewCell {

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

