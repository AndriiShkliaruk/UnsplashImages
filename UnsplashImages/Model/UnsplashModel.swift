//
//  UnsplashImage.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 01.09.2021.
//

import Foundation

struct UnsplashTopic: Decodable {
    let id: String
    let title: String
    let totalPhotos: Int
    let coverPhoto: UnsplashImage
}

struct UnsplashImage: Decodable {
    let id: String
    let color: String
    let urls: URLs
    let links: Links
}

struct URLs: Decodable {
    let raw, full, regular, small, thumb : String
}

struct Links: Decodable {
    let download: String
}
