//
//  AppManager.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import Foundation
import Alamofire
import NetworkService

public class AppManager {
    public static var shared = AppManager()
    public var network: NetworkServiceManager
    
    init() {
        network = NetworkServiceManager(session: Session.default)
    }
}
