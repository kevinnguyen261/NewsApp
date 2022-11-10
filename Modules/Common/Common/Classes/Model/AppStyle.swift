//
//  AppStyle.swift
//  NewsApp
//
//  Created by kevinguyen261 on 10/11/2022.
//

import Foundation
import Base

public class AppStyle {
    public static var shared = AppStyle()
    public var font: Font
    
    init() {
        self.font = Font()
    }
}
