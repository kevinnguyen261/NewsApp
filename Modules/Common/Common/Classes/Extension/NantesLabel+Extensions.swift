//
//  NantesLabel+Extensions.swift
//  Common
//
//  Created by kevinguyen261 on 10/11/2022.
//

import Nantes

public extension NantesLabel {
    func setDefaultTruncate(font: UIFont) {
        let attributes = [.font: font,
                          NSAttributedString.Key.foregroundColor: Color.blueFrench]
        attributedTruncationToken = NSAttributedString(string: "...more", attributes: attributes)
    }
}
