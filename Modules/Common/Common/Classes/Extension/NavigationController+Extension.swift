//
//  NavigationController+Extension.swift
//  Common
//
//  Created by kevinguyen261 on 10/11/2022.
//

import Foundation

public extension UINavigationController {
    func removeShadow() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .white
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        } else {
            navigationBar.shadowImage = UIImage()
        }
    }
}
