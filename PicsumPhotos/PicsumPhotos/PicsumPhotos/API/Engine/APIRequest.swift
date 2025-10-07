//
//  APIRequest.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 08.10.25.
//

protocol APIRequest {
    associatedtype Output: Decodable

    var scheme: API.Scheme { get }
    var host: String { get }
    var path: String { get }
    var method: API.Method { get }
    var parameters: [String: String] { get }
}
