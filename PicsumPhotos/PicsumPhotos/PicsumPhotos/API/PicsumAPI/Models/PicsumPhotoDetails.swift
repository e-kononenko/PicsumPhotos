//
//  PicsumPhotoDetails.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 09.10.25.
//

import Foundation

struct PicsumPhotoDetails: Decodable {
    let id: String
    let author: String
    let width: Double
    let height: Double
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

extension PicsumPhotoDetails {
    var toPhotoDetails: PhotoDetails {
        return .init(id: id, author: author, url: downloadURL, width: width, height: height)
    }
}
