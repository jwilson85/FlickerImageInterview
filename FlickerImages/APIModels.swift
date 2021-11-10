//
//  APIModels.swift
//  FlickerImages
//
//  Created by Wilson, Jeremy on 11/9/21.
//

import Foundation

protocol Mappable: Codable {
    init?(responseData: Data, strategy: JSONDecoder.KeyDecodingStrategy) throws
}

extension Mappable {
    public init?(responseData: Data, strategy: JSONDecoder.KeyDecodingStrategy) throws {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = strategy
            self = try decoder.decode(Self.self, from: responseData)
        } catch {
            print("Was unable to parse \(error)")
            throw error
        }
    }
}

// MARK: - PhotoData
struct PhotoData: Mappable {
    var photos: Photos?
    let stat: String?
}

// MARK: - Photos
struct Photos: Mappable {
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    var photo: [Photo]?
}

// MARK: - Photo
struct Photo: Mappable {
    
    
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?
    let ispublic: Int?
    let isfriend: Int?
    let isfamily: Int?
    let urlS: String?
    let heightS: Int?
    let widthS: Int?
    let urlM: String?
    let heightM: Int?
    let widthM: Int?
    let urlL: String?
    let heightL: Int?
    let widthL: Int?
}
