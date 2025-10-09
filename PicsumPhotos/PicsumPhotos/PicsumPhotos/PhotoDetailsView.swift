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
        NavigationStack {
            Group {
                if let details = store.state.photoDetails {
                    ScrollView {
                        KFImage(details.url)
                            .placeholder { _ in
                                ProgressView()
                            }

                            .resizable()
                            .scaledToFit()
                            .aspectRatio(
                                details.width / details.height,
                                contentMode: .fit
                            )
                            .frame(maxWidth: .infinity)

                        VStack(spacing: 0) {
                            row(title: "ID", value: details.id)
                            Divider()
                            row(title: "Author", value: details.author)
                            Divider()
                            row(title: "Width", value: String(Int(details.width)))
                            Divider()
                            row(title: "Height", value: String(Int(details.height)))
                            Divider()
                            row(title: "URL", value: details.url?.absoluteString ?? "—")
                        }
                    }
                } else {
                    EmptyView()
                }
            }
            .safeAreaInset(edge: .top) {
                if let errorText = store.errorText {
                    Text("Error loading photo details: \(errorText)")
                        .foregroundColor(.red)
                }
            }
            .overlay(alignment: .center) {
                if store.isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .padding(20)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .shadow(radius: 8)
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        store.send(.closeButtonTapped)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.toggleFavorite)
                    } label: {
                        Image(systemName: store.state.isFavorite ? "heart.fill" : "heart")
                            .renderingMode(.original)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }

        .onAppear {
            store.send(.didAppear)
        }
    }

    private func row(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }
}


#Preview {
    PhotoDetailsView(store: .init(initialState: .init(photoId: "0"), reducer: {
        PhotoDetailsFeature()
    }))
}

