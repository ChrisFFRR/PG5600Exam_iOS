//
//  Album.swift
//  Opus
//
//  Created by Christopher Marchand on 12/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import Foundation

/*
https://www.youtube.com/watch?v=tdxKIPpPDAI
*/
struct AlbumResponse: Decodable {
    var response: TopAlbums
}

// MARK: - TopAlbum
struct TopAlbums: Decodable {
    let albumDetails: [ArtistDetails]
}

// MARK: - Loved
struct ArtistDetails: Decodable {
    
    struct Loved: Decodable {
        let idAlbum, idArtist: String
        let strAlbum, strArtist, strArtistStripped, intYearReleased: String
        let strGenre: String
        let strAlbumThumb: String
    }
    let loved: [Loved]
}


