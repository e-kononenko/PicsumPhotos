//
//  PhotoDetailsView.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 09.10.25.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

public struct PhotoDetailsView: View {
    let store: StoreOf<PhotoDetailsFeature>

    public var body: some View {
        VStack {
            Text("Details")
            Button("Toggle Favorite") {
                store.send(.toggleFavorite)
            }
        }
        .onAppear {
            store.send(.didAppear)
        }
    }
}
