//
//  ViewControllerExtensions.swift
//  Common
//
//  Created by kevinguyen261 on 10/11/2022.
//

import UIKit
import Nantes

public protocol AlertAction {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}

public extension UIViewController {
    func showAlert(message: String, title: String = "Alert", confirmTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(
        title: String,
        message: String,
        options: [AlertAction],
        completion: @escaping ((AlertAction?) -> Void)
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        options.forEach { option in
            let alertAction = UIAlertAction(title: option.title, style: option.style) { _ in
                completion(option)
            }
            alert.addAction(alertAction)
        }
        
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
}
