//
//  ReccomendedArtist.swift
//  Opus
//
//  Created by Christopher Marchand on 05/12/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import Foundation


struct ReccomendedRoot: Codable {
    let similar: Similar

    enum CodingKeys: String, CodingKey {
        case similar = "Similar"
    }
}


struct Similar: Codable {
    let results: [Reccomended]

    enum CodingKeys: String, CodingKey {
        case results = "Results"
    }
}


struct Reccomended: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}
enum TypeEnum: String, Codable {
    case music = "music"
}
