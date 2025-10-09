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
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                state.$favorites.withLock {
                    _ = $0.insert("2")

                    _ = $0.insert("6")
                }
                return .none
            case .toggleFavorite:
                return .none
            }
        }
    }
}
