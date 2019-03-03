//
//  Constants.swift
//  HairUtility
//
//  Created by James Truong on 2/15/19.
//  Copyright © 2019 James Truong. All rights reserved.
//

import Foundation
import KeychainAccess


struct KeychainKeys {
    
//    static var userPk = Keychain.getKey(name: "userPk")
    static var userPk = Keychain.getKey(name: "userPk")
    static var companyPk = Keychain.getKey(name: "companyPk")
    static var authToken = Keychain.getKey(name: "authToken")

}

struct Key {
    
}
