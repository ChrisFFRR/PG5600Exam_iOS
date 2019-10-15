//
//  Top50AlbumReq.swift
//  Opus
//
//  Created by Christopher Marchand on 12/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import Foundation

enum AlbumError: Error {
    case noDataFound
    case cannotProcessData
}

class HttpRequest {
    let resourceURL:URL
    
    init() {
        let resourceString = "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func getTopAlbums(completionHandler: @escaping(Result<[ArtistDetails], AlbumError>) -> Void) {
       URLSession.shared.dataTask(with: resourceURL) { data, response, error in

        guard let jsonData = data else {
                completionHandler(.failure(.noDataFound))
                return
            }
            do {
                let albumResponse = try JSONDecoder().decode(AlbumResponse.self, from: jsonData)
                let albumDetails = albumResponse.topAlbums
                print(albumDetails[0].idArtist)

                completionHandler(.success(albumDetails))
            } catch {
                print(error)
                completionHandler(.failure(.cannotProcessData))
            }

        }.resume()
    }
    
}
