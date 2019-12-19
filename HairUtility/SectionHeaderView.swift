//
//  SectionHeaderView.swift
//  HairUtility
//
//  Created by James Truong on 10/14/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    

    lazy var sectionLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "This is a section"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionLabel)

        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
