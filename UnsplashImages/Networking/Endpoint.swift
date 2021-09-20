//
//  Endpoint.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 04.09.2021.
//

import Foundation

enum Endpoint {
    case topics
    case topicPhotos(id: String)
    case photo(id: String)
    case randomPhoto
    case searchPhotos(query: String)
    
    //Returns URL to Unsplash by setting specific case
    var url: URL {
        get {
            switch self {
            case .topics:
                return buildURLFrom(path: "/topics")
            case .topicPhotos(let id):
                return buildURLFrom(path: "/topics/\(id)/photos")
            case .photo(let id):
                return buildURLFrom(path: "/photos/\(id)")
            case .randomPhoto:
                return buildURLFrom(path: "/photos/random")
            case .searchPhotos(let query):
                return buildURLFrom(path: "/search/photos", parameters: ["query" : query])
            }
        }
    }
    
    
    private func buildURLFrom(path: String, parameters: [String: String] = [:]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = path
        
        let allParameters = prepareParameters(parameters: parameters)
        components.queryItems = allParameters.map { URLQueryItem(name: $0, value: $1)}

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
    
    
    //Merge pre-installed and new query parameters (new in priority)
    private func prepareParameters(parameters receivedParameters: [String: String]) -> [String: String] {
        var parameters = [String: String]()
        
        //Pre-installed parameters
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        parameters["client_id"] = "-UBKtf-Pb9qNmEJR0mxnJsiR5NuAiMMyyKBnbkTlD6s"
        
        parameters.merge(receivedParameters) { (_,new) in new }
        return parameters
    }
}





