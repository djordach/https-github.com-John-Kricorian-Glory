//
//  NetworkService.swift
//  GlorySDK
//
//  Created by John Kricorian on 06/07/2021.
//

import Foundation

protocol ServiceProtocol: AnyObject {
    func getDataFromXML(tagName: String, request: RequestDelegate, completion: @escaping GetElementsUseCaseCompletionHandler)
}

class Service: ServiceProtocol {
    
    let apiClient: ApiClient
        
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
        
    func getDataFromXML(tagName: String, request: RequestDelegate, completion: @escaping GetElementsUseCaseCompletionHandler) {
        apiClient.execute(request: request, tagName: tagName) { result in
            switch result {
            case let .success(response):
                completion(.success(response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}

