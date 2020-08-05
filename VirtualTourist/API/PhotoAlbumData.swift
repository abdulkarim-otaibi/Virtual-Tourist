//
//  PhotoAlbum.swift
//  VirtualTourist
//
//  Created by Abdulkrum Alatubu on 12/12/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import Foundation

struct PhotoAlbumData: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [photo]
}

// MARK: - Photo
struct photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    let urlS: String
    let heightS, widthS: Int

    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case urlS = "url_s"
        case heightS = "height_s"
        case widthS = "width_s"
    }
}

