//
//  CollectionExtensions.swift
//  Common
//
//  Created by kevinguyen261 on 10/11/2022.
//

import Foundation

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
