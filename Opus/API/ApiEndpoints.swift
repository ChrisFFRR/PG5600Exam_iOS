//
//  ApiEndpoints.swift
//  Opus
//
//  Created by Christopher Marchand on 15/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import Foundation

//https://matteomanferdini.com/network-requests-rest-apis-ios-swift/

protocol ApiEndPoint {
    associatedtype ModelType: Decodable
    var resourcePath: String { get }
}

extension ApiEndPoint {
    
}

