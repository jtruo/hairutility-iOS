//
//  UserSettingsCell.swift
//  HairLink
//
//  Created by James Truong on 6/18/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit

class UserSettingsCell: UITableViewCell {

    lazy var cellTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Company Settings"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupViews()
        

    }
    
    func setupViews() {
        self.addSubview(cellTitleLabel)
        cellTitleLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 14, bottom: 0, right: 0), size: .init(width: 200, height: 50))
   
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


