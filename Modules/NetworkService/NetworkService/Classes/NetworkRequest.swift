//
//  NetworkRequest.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import Foundation
import Alamofire

public protocol NetworkRequest {
    var domain: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: Any]? { get }
    var header: [String: String]? { get }
    var encoding: ParameterEncoding { get }
}

extension NetworkRequest {
    func makeUrl() throws -> URL {
        return try (domain + path).asURL()
    }
}
