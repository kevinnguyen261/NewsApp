//
//  NewsRequest.swift
//  NewsApp
//
//  Created by kevinguyen261 on 10/11/2022.
//

import Foundation
import Alamofire
import NetworkService
import Common

protocol RequestUseCase {
    func asRequest() -> NetworkRequest
}

enum NewsRequestUseCase: RequestUseCase {
    case list(page: Int, pageSize: Int, category: NewsCategory? = nil, keyword: String)
    
    func asRequest() -> NetworkRequest {
        switch self {
        case let .list(page, pageSize, category, keyword):
            var params: [String: Any] = ["page": page,
                                         "pageSize": pageSize,
                                         "apiKey": PrivateKey.apiKey,
                                         "q": keyword]
            if let category = category {
                params["category"] = category
            }
            return NewsListRequest(parameter: params)
        }
    }
}

struct NewsListRequest: NetworkRequest {
    var domain: String {
        return "https://newsapi.org/"
    }
    
    var path: String {
        return "v2/top-headlines"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: [String : Any]?
    
    var header: [String : String]? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
}
