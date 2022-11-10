//
//  Pagination.swift
//  NewsApp
//
//  Created by kevinguyen261 on 10/11/2022.
//

import Foundation

public struct Pagination<T: Codable> {
    public var data: [T] = []
    public var totalData: Int = 0
    
    public var canLoadmore: Bool {
        return totalData != 0 && data.count != totalData
    }
    
    public init() {}
    
    public init(data: [T], totalData: Int) {
        self.data = data
        self.totalData = totalData
    }
    
    public static func empty() -> Pagination<T> {
        return Pagination()
    }
}
