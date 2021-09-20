//
//  UnsplashModel.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 01.09.2021.
//

import Foundation

struct SearchResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [UnsplashPhoto]
}

struct UnsplashTopic: Decodable {
    let id: String
    let title: String
    let totalPhotos: Int
    let coverPhoto: UnsplashPhoto
}

struct UnsplashPhoto: Decodable {
    let id: String
    let user: User
    let width: Int
    let height: Int
    let color: String
    let urls: URLs
    let links: Links
}

struct User: Decodable {
    let name: String
}

struct URLs: Decodable {
    let raw, full, regular, small, thumb : URL
}

struct Links: Decodable {
    let download: URL
}

