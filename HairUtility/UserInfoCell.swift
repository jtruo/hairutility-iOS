//
//  UserInfoCell.swift
//  HairLink
//
//  Created by James Truong on 6/24/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import KeychainAccess
import Alamofire

class UserInfoCell: UITableViewCell {
    
    
    lazy var firstAndLastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "This is where you can edit your profile information"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        setupViews()
        getUserInfo()
    }
    
    func setupViews() {
        
        let stackView = UIStackView(arrangedSubviews: [firstAndLastNameLabel, phoneNumberLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
    
        self.addSubview(profileImageView)
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        profileImageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 80, height: 80)
//        Anchor this to something
        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    var authToken: String?
    var pk: String?
    
    fileprivate func getUserInfo() {
//        Option click
        
        
//        Keychain.getAuthToken { (authToken) in
//            self.authToken = authToken
//        }
//        guard let authToken = authToken else { return }
//
//        Keychain.getPk { (pk) in
//            self.pk = pk
//        }
//        guard let pk = pk else { return }
//
//        let headers = [
//            "Authorization": "Token \(authToken)"
//        ]
//        print(headers)
//
//        Alamofire.DataRequest.userRequest(requestType: "GET", appendingUrl: "api/v1/users/\(pk)/", extraHeaders: headers, parameters: nil, success: { (user) in
//            print(user.firstName)
//
////            guard let firstName = user.firstName else { return }
////            guard let lastName = user.lastName else { return }
////            guard let phoneNumber = user.phoneNumber else { return }
//
////            self.firstAndLastNameLabel.text = firstName + lastName
////            self.phoneNumberLabel.text = phoneNumber
//            print("Succeeded")
//        }) { (err) in
//            print(err)
//        }
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


