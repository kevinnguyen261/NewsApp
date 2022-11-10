//
//  AppManager.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import Foundation
import NetworkService
import Alamofire

class AppManager {
    static var shared = AppManager()
    var network: NetworkServiceManager
    
    init() {
        network = NetworkServiceManager(session: Session.default)
    }
}
