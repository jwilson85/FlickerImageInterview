//
//  APIController.swift
//  FlickerImages
//
//  Created by Wilson, Jeremy on 11/9/21.
//

import Foundation

protocol NetworkingProtocol {
    func requestCodable(_ url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ())
}

class APIController {
    static let searchEndpoint = SearchEndpoint()
}

class SearchEndpoint: NetworkingProtocol {
    
    func searchPhotos(text: String, page: Int, completionHandler: @escaping (PhotoData?, Error?) -> ()) {
        guard let url = URLEndpoint.searchPhotos(text: text, page: page).url else {return}
        
        self.requestCodable(url) { data, response, error in
            if let data = data {
                do {
                    let object = try PhotoData(responseData: data, strategy: .convertFromSnakeCase)
                    completionHandler(object, error)
                }catch  {
                    print(error)
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil,error)
            }
        }
    }
    
    func requestCodable(_ url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            print("here")
//            print(data ?? "")
            completionHandler(data,response,error)
        }
        task.resume()
    }
}
