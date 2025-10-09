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
    let width: Double
    let height: Double
}

struct PhotoDisplayModel: Identifiable, Equatable, Hashable {
    let id: String
    let author: String
    let imageURL: URL?
    let isFavorite: Bool
    let width: Double
    let height: Double

    init(photo: Photo, isFavorite: Bool) {
        self.id = photo.id
        self.author = photo.author
        self.imageURL = photo.url
        self.isFavorite = isFavorite
        self.width = photo.width
        self.height = photo.height
    }
}

struct AuthorSection: Identifiable, Hashable {
    var id: String { author }
    let author: String
    let photos: [PhotoDisplayModel]
}

@Reducer
struct PhotoListFeature {
    @Dependency(\.photoClient) var photoClient

    @ObservableState
    struct State: Equatable {
        var photos: [Photo] = [] {
            didSet {
                let displayModels = photos.map {
                    PhotoDisplayModel(photo: $0, isFavorite: false)
                }

                let grouped = Dictionary(grouping: displayModels, by: { $0.author })

                self.sections = grouped
                    .map { key, value in
                        AuthorSection(
                            author: key,
                            photos: value
                        )
                    }
                    .sorted { lhs, rhs in
                        lhs.author.localizedCaseInsensitiveCompare(rhs.author) == .orderedAscending
                    }
            }
        }
        var isLoading: Bool = false
        var errorText: String?
        var sections: [AuthorSection] = []
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
                state.errorText = nil

                return .run { send in
                    let photos = try await photoClient.getPhotos()
                    return await send(.fetchPhotosSuccess(photos))
                } catch: { error, send in
                    return await send(.fetchPhotosFailure(error))
                }
            case .fetchPhotosSuccess(let photos):
                state.isLoading = false
                state.photos = photos
                return .none
            case .fetchPhotosFailure(let error):
                state.isLoading = false
                state.errorText = "Failed to fetch photos: \(error)"
                return .none
            }
        }
    }
}

