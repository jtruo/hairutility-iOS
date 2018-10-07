//
//  Company.swift
//  HairLink
//
//  Created by James Truong on 7/30/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import Foundation


struct Company: Decodable {
    
    let pk: String
    let companyName: String
    let address: String
    let state: String
    let city: String
    let zipCode: String
    let phoneNumber: String
    let bio: String?
    let bannerImageUrl: String?
    let userSet: [User]
    
}
