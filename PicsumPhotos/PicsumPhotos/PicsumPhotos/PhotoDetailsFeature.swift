//
//  PhotoDetailsFeature.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 09.10.25.
//

import Foundation
import ComposableArchitecture

struct PhotoDetails: Identifiable, Equatable {
    let id: String
    let author: String
    let url: URL?
    let width: Double
    let height: Double
}

@Reducer
struct PhotoDetailsFeature {
    @ObservableState
    struct State: Equatable {
        let photoId: String
        var photoDetails: PhotoDetails?
        @Shared(.inMemory("favorites")) var favorites: Set<String> = .init([])
    }

    enum Action {
        case didAppear
        case toggleFavorite
        case fetchPhotoDetailsSuccess(PhotoDetails)
        case fetchPhotoDetailsFailure(Error)
    }

    @Dependency(\.photoClient) var photoClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                return .run { [photoId = state.photoId] send in
                    let photoDetails = try await photoClient
                        .getPhotoDetails(photoId)
                    await send(.fetchPhotoDetailsSuccess(photoDetails))
                } catch: { error, send in
                    await send(.fetchPhotoDetailsFailure(error))
                }
            case .toggleFavorite:
                
                return .none

            case .fetchPhotoDetailsSuccess(let photoDetails):
                state.photoDetails = photoDetails
                return .none

            case .fetchPhotoDetailsFailure(let error):
                return .none
            }
        }
    }
}
