//
//  Track.swift
//  Muzika
//
//  Created by Firas Soltani on 12/10/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import Foundation

struct imageDetail : Codable {
    let url : String
}

struct albumDetails : Codable {
    let name : String
    let images : [imageDetail]
}

struct trackDetails: Codable {
    let name : String?
    let preview_url : String?
    let album : albumDetails?
}

struct items : Codable {
    let track : trackDetails
}

struct tracks : Codable {
    let items : [items]
}
