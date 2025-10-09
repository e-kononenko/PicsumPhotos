//
//  PicsumPhotosRequest.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 08.10.25.
//

struct PicsumPhotosRequest: APIRequest {
    typealias Output = [PicsumPhoto]
    let scheme: API.Scheme = .https
    let host: String = PicsumAPI.host
    let method: API.Method = .get
    let parameters: [String : String] = [:]
    let path: String = "/v2/list"
}
