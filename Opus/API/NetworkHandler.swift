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
}



class NetworkHandler {
    
    typealias result<T> = (Result<[T], DataError>) -> Void
    
    let resourceURL:URL
    
    init(from url:String) {
        let resourceString = url
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    /*
    func request<T: Decodable>(type: T.Type,
                               from url: URL,
                               completionHandler: @escaping result<T>) -> Void {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            
            if let jsondata = data {
                do {
                    let decodedJson: [T] = try JSONDecoder().decode([T].self, from: data)
                    completionHandler(.success(decodedJson))
                }
            }
        }

    }
 */
    
    
    func request<T:Decodable>(completionHandler: @escaping(Result<[T], DataError>) -> Void) {
        
        
       URLSession.shared.dataTask(with: resourceURL) { data, response, error in

        guard let jsonData = data else {
                completionHandler(.failure(.noDataFound))
                return
            }
            do {
                let decodedJson = try JSONDecoder().decode([T].self, from: jsonData)
               
                completionHandler(.success(decodedJson))
            } catch {
                print(error)
                completionHandler(.failure(.cannotProcessData))
            }

        }.resume()
    }
    
}
