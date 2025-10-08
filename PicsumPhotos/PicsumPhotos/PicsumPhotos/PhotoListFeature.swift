//
//  PhotoListFeature.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 06.10.25.
//
import Foundation
import ComposableArchitecture

struct Photo: Identifiable, Equatable {
    let id: String
    let author: String
    let url: URL?
}

struct PhotoDisplayModel: Identifiable, Equatable {
    let id: String
    let author: String
    let imageURL: URL?
}

@Reducer
struct PhotoListFeature {
    @Dependency(\.photoClient) var photoClient

    @ObservableState
    struct State: Equatable {
        var photos: [PhotoDisplayModel] = []
        var isLoading: Bool = false
        var errorText: String?
    }

    enum Action {
        case didAppear
        case fetchPhotosSuccess([Photo])
        case fetchPhotosFailure(Error)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                state.isLoading = true
                return .run { send in
                    let photos = try await photoClient.getPhotos()
                    return await send(.fetchPhotosSuccess(photos))
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

                } catch: { error, send in
                    return await send(.fetchPhotosFailure(error))
                }
            case .fetchPhotosSuccess(let photos):
                state.isLoading = false

                let displayModels = photos.map { PhotoDisplayModel(id: $0.id, author: $0.author, imageURL: $0.url) }

                state.photos = displayModels

                return .none
            case .fetchPhotosFailure(let error):
                state.isLoading = false
                state.errorText = "Failed to fetch photos: \(error)"
                return .none
            }
        }
    }
}

