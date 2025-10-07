//
//  APIClient.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 08.10.25.
//

import ComposableArchitecture
import Foundation

enum APIClient {
    static func fetch<Request: APIRequest>(request: Request) async throws -> Request.Output {
        let urlRequest = try request.toURLRequest()
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw API.Error.invalidResponse(statusCode: nil)
        }

        guard 200 ..< 300 ~= statusCode else {
            throw API.Error.invalidResponse(statusCode: statusCode)
        }

        return try JSONDecoder.requestsJsonDecoder
            .decode(Request.Output.self, from: data)
    }
}

fileprivate extension APIRequest {
    func toURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard var urlRequest = components.url.map({ URLRequest(url: $0) }) else {
            throw API.Error.invalidRequest
        }
        urlRequest.httpMethod = method.rawValue

        return urlRequest
    }
}

fileprivate extension JSONDecoder {
    static let requestsJsonDecoder: JSONDecoder = .init()
}
