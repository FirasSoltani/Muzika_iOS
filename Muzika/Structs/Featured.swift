//
//  Playlist.swift
//  Muzika
//
//  Created by Firas Soltani on 11/25/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import Foundation


struct imageObject: Codable {
    let url: String?
}

struct itemStructure: Codable {
    let id: String?
    let href: String?
    let name: String?
    let description: String?
    let images: [imageObject]
}

struct playlistsContainer: Codable{
    let items : [itemStructure]
}

struct Featured: Codable {
    let href: String?
    let playlists: playlistsContainer
}

