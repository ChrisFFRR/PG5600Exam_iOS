//
//  Artist.swift
//  Opus
//
//  Created by Christopher Marchand on 12/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import Foundation

// JSON: - Root
struct TopAlbumRoot : Decodable {
    var topAlbums: [TopAlbum]

    enum CodingKeys: String, CodingKey {
        case topAlbums = "loved"
    }
}

struct TopAlbum: Codable {
    
    let idAlbum, idArtist: String
    let strAlbum, strArtist, strArtistStripped, intYearReleased: String
    let strGenre: String
    let strAlbumThumb: String
    
}

struct AlbumRoot: Decodable {
    let album: [Album]
    
    enum CodingKeys: String,  CodingKey {
        case album = "track"
    }
}

struct Album: Codable {
    let strTrack, strDuration: String
  
    enum CodingKeys: String, CodingKey {
        case strTrack
        case strDuration = "intDuration"
    }
}





