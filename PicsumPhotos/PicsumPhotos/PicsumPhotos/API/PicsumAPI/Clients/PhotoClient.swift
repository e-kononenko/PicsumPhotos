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

    //                    try await send(
    //                        .fetchPhotosSuccess(
    //                            [
    //                                .init(
    //                                    id: "0",
    //                                    author: "Alejandro Escamilla",
    //                                    url: .init(string: "https://picsum.photos/id/0/5000/3333")!
    //                                ),
    //                                .init(
    //                                    id: "1",
    //                                    author: "Alejandro Escamilla",
    //                                    url: .init(string: "https://picsum.photos/id/1/5000/3333")!
    //                                ),
    //                                .init(
    //                                    id: "17",
    //                                    author: "Paul Jarvis",
    //                                    url: .init(string: "https://picsum.photos/id/3/5000/3333")!
    //                                )
    //                            ]
    //                        )
    //                    )

}

extension DependencyValues {
  var photoClient: PhotoClient {
    get { self[PhotoClient.self] }
    set { self[PhotoClient.self] = newValue }
  }
}
