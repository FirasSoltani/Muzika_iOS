//
//  Post.swift
//  Muzika
//
//  Created by Firas Soltani on 12/16/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import Foundation


struct PostHolder : Codable {
    var id : Int?
    var postContent :  String?
    var playlistId : String?
    var user_id : Int?
}
