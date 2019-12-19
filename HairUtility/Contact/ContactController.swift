//
//  ContactController.swift
//  HairUtility
//
//  Created by James Truong on 5/18/19.
//  Copyright © 2019 James Truong. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess
import AWSS3
import Kingfisher

class ContactController: UIViewController, UINavigationControllerDelegate {
    

    lazy var generalInfoTextView: UITextView = {
        let tv = UITextView()
        tv.text = """
        If you have any issues with the app or suggestions for
        making the app better, don't hesitate to contact me at:
        """
        tv.textColor = UIColor.mainCharcoal()
        tv.tintColor = UIColor.mainCharcoal()
        tv.isEditable = false
     
        tv.font = UIFont.boldSystemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.frame = CGRect(x: 0, y: 0, width: 0, height: 80)
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()
    
    lazy var emailLabel: BaseTextLabel = {
        let tv = BaseTextLabel()
        tv.text = "Email: jtruong@hairutility.com"
      
        return tv
    }()
    
    
    lazy var phoneLabel: BaseTextLabel = {
        let tv = BaseTextLabel()
        tv.text = "Phone: 260-705-9188"
        return tv
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Contact Me"
        
        view.backgroundColor = .white
        
        setupInputFields()
        
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [generalInfoTextView, emailLabel, phoneLabel])
        
        
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 180))
    }
    
}

