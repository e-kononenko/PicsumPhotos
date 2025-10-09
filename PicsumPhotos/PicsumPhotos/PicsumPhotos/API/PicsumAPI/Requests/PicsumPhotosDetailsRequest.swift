//
//  Untitled.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 09.10.25.
//

struct PicsumPhotosDetailsRequest: APIRequest {
    typealias Output = PicsumPhotoDetails
    let scheme: API.Scheme = .https
    let host: String = PicsumAPI.host
    let method: API.Method = .get
    let parameters: [String : String] = [:]

    var path: String {
        "/id/\(photoId)/info"
    }

    let photoId: String
}
