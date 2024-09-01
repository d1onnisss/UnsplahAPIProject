//
//  Model.swift
//  Geeks
//
//  Created by Alexey Lim on 12/8/24.
//

struct UnsplashPhoto: Codable {
    let id: String
    let createdAt: String
    let description: String?
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case description
        case urls
    }
}

struct Urls: Codable {
    let regular: String

    enum CodingKeys: String, CodingKey {
        case regular
    }
}
