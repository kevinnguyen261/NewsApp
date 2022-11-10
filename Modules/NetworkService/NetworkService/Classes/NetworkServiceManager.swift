//
//  NetworkServiceManager.swift
//  NewsApp
//
//  Created by kevinnguyen261 on 10/11/2022.
//

import Foundation
import Alamofire
import RxSwift

public class NetworkServiceManager {
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    public func requestCodable<T: Codable>(request: NetworkRequest) -> Single<T> {
        return Single.create { single in
            do {
                let url = try request.makeUrl()
                var httpHeaders: HTTPHeaders?
                if let header = request.header {
                    httpHeaders = HTTPHeaders(header)
                }
                let request = self.session.request(
                    url,
                    method: request.method,
                    parameters: request.parameter,
                    encoding: URLEncoding.default,
                    headers: httpHeaders
                )
                request.responseDecodable { (response: AFDataResponse<T>) in
                    #if DEBUG
                    print(request.cURLDescription())
                    print("RESPONSE:\n" + (String(data: response.data ?? Data(), encoding: .utf8) ?? ""))
                    #endif
                    switch response.result {
                    case .success(let decodedResponse):
                        single(.success(decodedResponse))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    public func requestArrayCodable<T: Codable>(request: NetworkRequest) -> Single<[T]> {
        return Single.create { single in
            do {
                let url = try request.makeUrl()
                var httpHeaders: HTTPHeaders?
                if let header = request.header {
                    httpHeaders = HTTPHeaders(header)
                }
                let request = self.session.request(
                    url,
                    method: request.method,
                    parameters: request.parameter,
                    encoding: URLEncoding.default,
                    headers: httpHeaders
                )
                request.responseDecodable { (response: AFDataResponse<[T]>) in
                    #if DEBUG
                    print(request.cURLDescription())
                    print("RESPONSE:\n" + (String(data: response.data ?? Data(), encoding: .utf8) ?? ""))
                    #endif
                    switch response.result {
                    case .success(let decodedResponse):
                        single(.success(decodedResponse))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
