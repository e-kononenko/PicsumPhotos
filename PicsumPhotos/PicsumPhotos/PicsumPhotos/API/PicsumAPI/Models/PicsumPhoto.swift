//
//  APIPhoto.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 08.10.25.
//

import Foundation

struct PicsumPhoto: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: URL
    let downloadURL: URL

    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadURL = "download_url"
    }
}

extension PicsumPhoto {
    var toPhoto: Photo {
        return Photo(id: id, author: author, url: downloadURL)
    }
}
