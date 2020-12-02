//
//  User.swift
//  Muzika
//
//  Created by Firas Soltani on 11/25/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import Foundation


struct images: Codable{
    let url: String?
}
struct followers: Codable{
    let total: Int?
}

struct user: Codable {
    let display_name: String?
    let id: String?
    let followers: followers?
    let images: [images]?
    let username: String?
    let email: String?
    let accessToken: String?
}
