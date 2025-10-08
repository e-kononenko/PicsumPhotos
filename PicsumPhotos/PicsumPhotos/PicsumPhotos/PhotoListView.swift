//
//  PhotoListView.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 06.10.25.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct PhotoListView: View {
    let store: StoreOf<PhotoListFeature>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.photos) { photo in
                    Button {

                    } label: {
                        HStack {
                            KFImage(photo.imageURL)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 44, height: 44, alignment: .center)
                                .clipped()

                            Text(photo.author)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "heart")
                                .renderingMode(.original)
                                .foregroundStyle(.primary)
                        }
                    }
                    .tint(.primary)
                }
            }
            .navigationTitle("Photos")
        }
        .onAppear {
            store.send(.didAppear)
        }
    }
}

#Preview {
    PhotoListView(store: Store(initialState: PhotoListFeature.State(), reducer: {
        PhotoListFeature()
    }))
}

