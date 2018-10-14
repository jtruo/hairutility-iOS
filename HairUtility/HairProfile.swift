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
    let firstImageUrl: String
    let secondImageUrl: String
    let thirdImageUrl: String
    let fourthImageUrl: String
    let profileDescription: String
    let tags: [String]

}

struct CoreHairProfile: Codable {

    let hairstyleName: String
    let profileDescription: String
    let creationDate: String
    
}

