//
//  Album.swift
//  Opus
//
//  Created by Christopher Marchand on 12/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import Foundation

// JSON: - Root
struct AlbumResponse: Decodable {
    var topAlbums: [ArtistDetails]
    
    enum CodingKeys: String, CodingKey {
        case topAlbums = "loved"
    }
}

// JSON: - Loved
struct ArtistDetails: Decodable {
    
    let idAlbum, idArtist: String
    let strAlbum, strArtist, strArtistStripped, intYearReleased: String
    let strGenre: String
    let strAlbumThumb: String
    
}


