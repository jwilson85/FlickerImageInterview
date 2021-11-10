//
//  URLEndpoint.swift
//  FlickerImages
//
//  Created by Wilson, Jeremy on 11/9/21.
//

import Foundation

struct URLEndpoint {
    
    
    let path: String
    var queryItems: [URLQueryItem]
    let host: String
    
    //REMAX-Beta is getting set to can be changed
    //The REMAX scheme will always be prod
    init(path: String = "/services/rest",
         queryItems: [URLQueryItem],
         host: String = "api.flickr.com") {
        self.path = path
        self.host = host
        self.queryItems = queryItems
        self.queryItems.append(URLQueryItem(name: "api_key", value: "1508443e49213ff84d566777dc211f2a"))
        self.queryItems.append(URLQueryItem(name: "format", value: "json"))
        self.queryItems.append(URLQueryItem(name: "nojsoncallback", value: "1"))
    }
}

extension URLEndpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }

    static func getPhotos() -> URLEndpoint {
        
        let queryItems = [URLQueryItem(name: "method", value: "flickr.galleries.getPhotos")]
        return URLEndpoint(queryItems: queryItems)
    }
    
    static func searchPhotos(text: String, page: Int) -> URLEndpoint {
        let queryItems = [URLQueryItem(name: "method", value: "flickr.photos.search"),
                          URLQueryItem(name: "text", value: text),
                          URLQueryItem(name: "per_page", value: "25"),
                          URLQueryItem(name: "content_type", value: "7"),
                          URLQueryItem(name: "extras", value: "url_s,url_m,url_l"),
                          URLQueryItem(name: "page", value: String(page))
                          
                          
        ]
        return URLEndpoint(queryItems: queryItems)
    }
    
    
}
