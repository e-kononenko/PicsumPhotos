//
//  PicsumPhotosApp.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 06.10.25.
//

import SwiftUI
import ComposableArchitecture

@main
struct PicsumPhotosApp: App {
    var body: some Scene {
        WindowGroup {
            PhotoListView(store: Store(initialState: PhotoListFeature.State(), reducer: {
                PhotoListFeature()
            }))
        }
    }
}
