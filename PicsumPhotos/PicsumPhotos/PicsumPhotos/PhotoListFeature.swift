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


struct PhotoListFeature {
    @ObservableState
    struct State: Equatable {
        var photos: [Photo] = []
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
                return .none
            case .fetchPhotosSuccess(let photos):
                return .none
            case .fetchPhotosFailure(let error):
                return .none
            }
        }
    }
}
