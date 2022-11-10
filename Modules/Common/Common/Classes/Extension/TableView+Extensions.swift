//
//  TableView+Extensions.swift
//  Common
//
//  Created by kevinguyen261 on 10/11/2022.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        let nibName = String(describing: type)
        register(UINib(nibName: nibName, bundle: Bundle(for: T.self)), forCellReuseIdentifier: nibName)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let nibName = String(describing: type)
        return dequeueReusableCell(withIdentifier: nibName, for: indexPath) as! T
    }
}
