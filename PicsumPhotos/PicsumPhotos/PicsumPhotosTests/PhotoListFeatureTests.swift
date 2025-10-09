//
//  PhotoListFeatureTests.swift
//  PicsumPhotos
//
//  Created by Evgenii Kononenko on 09.10.25.
//

import ComposableArchitecture
import Testing
import Foundation

@testable import PicsumPhotos

@Test
func photos() async {
    let store = await TestStore(initialState: PhotoListFeature.State()) {
        PhotoListFeature()
    } withDependencies: {
        $0.photoClient.getPhotos = { mockPhotos }
    }

    await store.send(.didAppear) {
        $0.isLoading = true
    }

    await store.receive(\.fetchPhotosSuccess) {
        $0.isLoading = false
        $0.photos = mockPhotos
        //$0.sections.count = 2
    }

    await #expect(store.state.sections.count == 2)
    await #expect(store.state.sections[0].photos.count == 2)
    await #expect(store.state.sections[0].photos.map(\.id) == ["0", "1"])
    await #expect(store.state.sections[1].photos.count == 1)
    await #expect(store.state.sections[1].photos.map(\.id) == ["2"])
    await #expect(store.state.sections.map(\.author) == ["Alejandro Escamilla", "Another author"])
}

@Test
func testPhotoDetailsPresentation() async {
    let store = await TestStore(initialState: PhotoListFeature.State()) {
        PhotoListFeature()
    } withDependencies: {
        $0.photoClient.getPhotos = { mockPhotos }
    }

    await store.send(.rowTapped(photoId: "0")) {
        $0.photoDetails = PhotoDetailsFeature.State(photoId: "0")
    }
}

let mockPhotos: [Photo] =
[
    .init(
        id: "0",
        author: "Alejandro Escamilla",
        url: .init(string: "https://picsum.photos/id/0/5000/3333")!,
        width: 5000,
        height: 3333
    ),
    .init(
        id: "1",
        author: "Alejandro Escamilla",
        url: .init(string: "https://picsum.photos/id/1/5000/3333")!,
        width: 5000,
        height: 3333
    ),
    .init(
        id: "2",
        author: "Another author",
        url: .init(string: "https://picsum.photos/id/1/5000/3333")!,
        width: 5000,
        height: 3333
    ),
]

