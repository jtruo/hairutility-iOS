//
//  Post.swift
//  HairLink
//
//  Created by James Truong on 8/2/17.
//  Copyright © 2017 James Truong. All rights reserved.
//

import Foundation


struct RawApiResponse: Decodable {
    let count: Int
    let results: [HairProfile]
}

struct HairProfile: Decodable {

    let pk: String?
    let user: String?
    let creator: String
    let hairstyleName: String
    let thumbnailKey: String
    let firstImageKey: String
    let secondImageKey: String
    let thirdImageKey: String
    let fourthImageKey: String
    let profileDescription: String
    let accessCode: String
    let tags: [String]

}

struct CoreHairProfile: Codable {

    let pk: String
    let hairstyleName: String
    let profileDescription: String
    let creationDate: String
    
}

