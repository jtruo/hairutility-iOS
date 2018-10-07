//
//  bottomBorderTextField.swift
//  HairLink
//
//  Created by James Truong on 8/3/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit


class BottomBorderTextField: UITextField{
    
    var hasError: Bool = false {
        didSet {
            if (hasError) {
                self.borders(for: [UIRectEdge.bottom], color: .red)
            } else {
                self.borders(for: [UIRectEdge.bottom], color: .lightGray)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borders(for: [UIRectEdge.bottom], color: .lightGray)
        self.font = UIFont.systemFont(ofSize: 14)
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
        self.autocorrectionType = .no

   
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


