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
        @Presents var photoDetails: PhotoDetailsFeature.State?

        var photos: [Photo] = []

        var sections: [AuthorSection] {
            let displayModels = photos.map {
                PhotoDisplayModel(photo: $0, isFavorite: self.favorites.contains($0.id))
            }
            let grouped = Dictionary(grouping: displayModels, by: { $0.author })
            return grouped
                .map { AuthorSection(author: $0.key, photos: $0.value) }
                .sorted { $0.author.localizedCaseInsensitiveCompare($1.author) == .orderedAscending }
        }

        @Shared(.inMemory("favorites")) var favorites: Set<String> = .init(["0", "1"])

        var isLoading: Bool = false
        var errorText: String?

    }

    enum Action {
        case didAppear
        case fetchPhotosSuccess([Photo])
        case fetchPhotosFailure(Error)

        case rowTapped(photoId: String)
        case details(PresentationAction<PhotoDetailsFeature.Action>)
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

            case .rowTapped(let photoId):
                state.photoDetails = .init(photoId: photoId)
                return .none

            case .details:
                // do nothing, the child view shares the state and handles its own work
                return .none
            }
        }
        .ifLet(\.$photoDetails, action: \.details) {
            PhotoDetailsFeature()
        }
    }
}

