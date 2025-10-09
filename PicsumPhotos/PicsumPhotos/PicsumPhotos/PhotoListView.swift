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
                ForEach(store.state.sections) { section in
                    Section(header: Text(section.author)) {
                        ForEach(section.photos) { photo in
                            Button {

                            } label: {
                                PhotoRowView(photo: photo)
                            }
                            .tint(.primary)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                if let errorText = store.errorText {
                    Text("Error loading photos: \(errorText)")
                        .foregroundColor(.red)
                }
            }
            .overlay(alignment: .center) {
                if store.isLoading && store.state.sections.isEmpty {
                    ProgressView("Loading…")
                        .controlSize(.large)
                        .padding(20)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .shadow(radius: 8)
                }
            }
            .disabled(store.state.sections.isEmpty)
            .navigationTitle("Photos")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .onAppear {
            store.send(.didAppear)
        }
    }
}

struct PhotoRowView: View {
    let photo: PhotoDisplayModel

    var body: some View {
        HStack {
            KFImage(photo.imageURL)
                .placeholder { p in
                    ProgressView(p)
                }
                .downsampling(
                    size: CGSize(
                        width: photo.width / 100.0,
                        height: photo.height / 100.0
                    )
                )
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
}

#Preview {
    PhotoListView(store: Store(initialState: PhotoListFeature.State(), reducer: {
        PhotoListFeature()
    }))
}

