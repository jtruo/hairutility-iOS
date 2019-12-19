//
//  Company Settings.swift
//  HairLink
//
//  Created by James Truong on 8/3/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import Foundation

import UIKit
import KeychainAccess
import Alamofire

class CompanySettingsCell: UITableViewCell {
    
    
    lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.text = "Company"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        setupViews()

    }
    
    func setupViews() {
        
        self.addSubview(companyLabel)
        
        companyLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, size: .init(width: 200, height: 50))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
