//
//  UnsplashImage.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 01.09.2021.
//

import Foundation

struct UnsplashImage: Codable {
    let id: String
    let color: String
    let urls: URLs
    let links: Links
}

struct URLs: Codable {
    let raw, full, regular, small, thumb : String
}

struct Links: Codable {
    let download: String
}
