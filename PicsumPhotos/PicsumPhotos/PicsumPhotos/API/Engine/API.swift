//
//  API.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 08.10.25.
//

enum API {
    public enum Method: String {
        case get = "GET"
    }

    public enum Scheme: String {
        case https = "HTTPS"
    }

    public enum Error: Swift.Error {
        case invalidRequest
        case invalidResponse(statusCode: Int?)
    }
}
