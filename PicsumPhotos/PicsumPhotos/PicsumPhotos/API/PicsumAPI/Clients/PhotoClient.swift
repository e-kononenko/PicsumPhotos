//
//  PhotoClient.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 08.10.25.
//

import ComposableArchitecture

struct PhotoClient {
    var getPhotos: () async throws -> [Photo]
}


// MARK: - Live API implementation
extension PhotoClient: DependencyKey {
    static var liveValue: PhotoClient {
        return PhotoClient {
            let request = PicsumPhotosRequest()
            let apiPhotos = try await APIClient.fetch(request: request)
            let photos = apiPhotos.map(\.toPhoto)
            return photos
        }
    }
}

extension DependencyValues {
  var photoClient: PhotoClient {
    get { self[PhotoClient.self] }
    set { self[PhotoClient.self] = newValue }
  }
}
