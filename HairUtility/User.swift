//
//  User.swift
//  HairLink
//
//  Created by James Truong on 8/3/17.
//  Copyright © 2017 James Truong. All rights reserved.
//

import Foundation

struct User: Decodable {
//Could implement coding keys instead of all optionals
    let pk: String
    let authToken: String
    let isActive: Bool
    let isStylist: Bool
    let firstName: String?
    let lastName: String?
    let email: String?
    let phoneNumber: String?
    let profileImageUrl: String?
    let hairProfiles: [HairProfile]?
    
}

