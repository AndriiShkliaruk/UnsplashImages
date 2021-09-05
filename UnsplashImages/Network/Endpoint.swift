//
//  Endpoint.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 04.09.2021.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = UnsplashConfiguration.shared.apiURL
        components.path = path
        components.queryItems = queryItems
        components.queryItems?.append(URLQueryItem(name: "client_id", value: UnsplashConfiguration.shared.accessKey))
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}



extension Endpoint {
    
    static func topics(page: Int = 1, itemsPerPage: Int = 10) -> Self {
        Endpoint(path: "/topics", queryItems: [URLQueryItem(name: "page", value: String(page)),
                                              URLQueryItem(name: "per_page", value: String(itemsPerPage))])
    }
    
    static func topicPhotos(id: String, page: Int = 1, itemsPerPage: Int = 10) -> Self {
        Endpoint(path: "/topics/\(id)/photos", queryItems: [URLQueryItem(name: "page", value: String(page)),
                                                           URLQueryItem(name: "per_page", value: String(itemsPerPage))])
    }
    
    static func photo(id: String) -> Self {
        Endpoint(path: "/photos/\(id)")
    }
    
    static func searchPhotos(query: String, page: Int = 1, itemsPerPage: Int = 10) -> Self {
        Endpoint(path: "/search/photos", queryItems: [URLQueryItem(name: "query", value: String(query)),
                                                      URLQueryItem(name: "page", value: String(page)),
                                                      URLQueryItem(name: "per_page", value: String(itemsPerPage))])
    }
}




