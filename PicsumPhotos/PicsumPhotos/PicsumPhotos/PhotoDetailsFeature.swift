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
        var isLoading = false
        var errorText: String?

        var isFavorite: Bool {
            return favorites.contains(photoId)
        }
    }

    enum Action {
        case didAppear
        case toggleFavorite
        case fetchPhotoDetailsSuccess(PhotoDetails)
        case fetchPhotoDetailsFailure(Error)
        case closeButtonTapped
    }

    @Dependency(\.photoClient) var photoClient
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                state.isLoading = true
                state.errorText = nil
                return .run { [photoId = state.photoId] send in
                    let photoDetails = try await photoClient.getPhotoDetails(photoId)
                    await send(.fetchPhotoDetailsSuccess(photoDetails))
                } catch: { error, send in
                    await send(.fetchPhotoDetailsFailure(error))
                }

            case .toggleFavorite:
                state.$favorites.withLock {
                    if state.isFavorite {
                        _ = $0.remove(state.photoId)
                    } else {
                        _ = $0.insert(state.photoId)
                    }
                }
                return .none

            case .fetchPhotoDetailsSuccess(let details):
                state.isLoading = false
                state.photoDetails = details
                return .none

            case .fetchPhotoDetailsFailure(let error):
                state.isLoading = false
                state.errorText = "Failed to load details: \(error.localizedDescription)"
                return .none

            case .closeButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}
