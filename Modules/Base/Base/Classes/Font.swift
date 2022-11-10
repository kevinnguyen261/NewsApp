//
//  AppStyle.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import UIKit

public struct Font {
    var familyName: String?
    
    public init(familyName: String? = nil) {
        self.familyName = familyName
    }
    
    public func regular(size: CGFloat) -> UIFont {
        if let familyName = familyName,
           let font = UIFont(name: familyName + "-Regular", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    public func medium(size: CGFloat) -> UIFont {
        if let familyName = familyName,
           let font = UIFont(name: familyName + "-Medium", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    public func semiBold(size: CGFloat) -> UIFont {
        if let familyName = familyName,
           let font = UIFont(name: familyName + "-Semibold", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    public func bold(size: CGFloat) -> UIFont {
        if let familyName = familyName,
           let font = UIFont(name: familyName + "-Bold", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
