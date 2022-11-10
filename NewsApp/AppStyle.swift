//
//  AppStyle.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import Foundation
import Base

class AppStyle {
    static var shared = AppStyle()
    var font: Font
    
    init() {
        self.font = Font()
    }
}
