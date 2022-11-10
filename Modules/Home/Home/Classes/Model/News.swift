//
//  News.swift
//  NewsApp
//
//  Created by kevinguyen261 on 10/11/2022.
//

import UIKit
import Common

class NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [News]
}

class News: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    // for expand display
    var isExpand = false
    
    enum CodingKeys: String, CodingKey {
        case author, title, description, url, urlToImage, publishedAt, content
    }
    
    func getNumberOfLines() -> Int {
        return isExpand ? 0 : 2
    }
}

enum NewsCategory: CaseIterable {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

extension NewsCategory: AlertAction {
    var title: String {
        switch self {
        case .business:
            return "Business"
        case .entertainment:
            return "Entertainment"
        case .general:
            return "General"
        case .health:
            return "Health"
        case .science:
            return "Science"
        case .sports:
            return "Sports"
        case .technology:
            return "Technology"
        }
    }
    
    var style: UIAlertAction.Style {
        return .default
    }
}
