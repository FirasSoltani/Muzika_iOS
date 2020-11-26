//
//  Playlist.swift
//  Muzika
//
//  Created by Firas Soltani on 11/25/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import Foundation


struct image: Codable {
    let url: String?
}

struct item: Codable {
    let href: String?
    let name: String?
    let description: String?
    let images: [image]
    
}
struct playlistStructure: Codable {
    
    let href: String?
    let items: [item]
}

