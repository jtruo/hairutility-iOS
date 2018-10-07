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
//    Convert the struct to Result? Or a custom struct that returns the count, previous, etc, values, and then nest the hairprofiles. Pagination also works on the client levels though
    let pk: String
    let user: String
    let firstName: String
    let creator: String
    let hairstyleName: String
    let firstImageUrl: String
    let secondImageUrl: String
    let thirdImageUrl: String
    let fourthImageUrl: String
    let profileDescription: String
    let tags: [String]

}


