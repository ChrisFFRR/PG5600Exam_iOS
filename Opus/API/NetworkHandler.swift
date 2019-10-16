//
//  Top50AlbumReq.swift
//  Opus
//
//  Created by Christopher Marchand on 12/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import Foundation

enum DataError: Error {
    case noDataFound
    case cannotProcessData
    case badResponse
}



class NetworkHandler {
    
    typealias result<T> = (Result<[T], DataError>) -> Void
    
    let resourceURL:URL
    
    init(from url:String) {
        let resourceString = url
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    

    
    func request<T:Decodable>(type: T.Type, completionHandler: @escaping(result<T>)) {
        
        
        URLSession.shared.dataTask(with: resourceURL) { (data, response, _) in
            
            guard let jsonData = data else {
                completionHandler(.failure(.noDataFound))
                return
            }
            
            
            guard response != nil else {
                completionHandler(.failure(.badResponse))
                return
            }
            
            do {
                let decodedJson = try JSONDecoder().decode(T.self, from: jsonData)
                completionHandler(.success([decodedJson]))
            } catch {
                print(error)
                completionHandler(.failure(.cannotProcessData))
            }
            
        }.resume()
    }
    
}
