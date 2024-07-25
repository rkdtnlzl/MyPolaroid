//
//  SearchPhoto.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/25/24.
//

import Foundation

struct SearchPhotoResponse: Decodable {
    let results: [SearchPhoto]
}

struct SearchPhoto: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: SearchURLS
    let likes: Int
    let user: SearchUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case likes
        case user
    }
}

struct SearchURLS: Decodable {
    let raw: String
    let small: String
}

struct SearchUser: Decodable {
    let name: String
    let profileImage: SearchProfileImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}

struct SearchProfileImage: Decodable {
    let medium: String
}
