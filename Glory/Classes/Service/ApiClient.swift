//
//  ApiClient.swift
//  GlorySDK
//
//  Created by John Kricorian on 06/07/2021.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

protocol ApiClient: AnyObject {
    func execute(request: RequestDelegate, tagName: String, completionHandler: @escaping (Result<[XMLNode], Error>) -> Void)
}

extension URLSession: URLSessionProtocol {}

 public class ApiClientImplementation: NSObject, ApiClient {

    let urlSession: URLSessionProtocol
    
    init(urlSessionConfiguration: URLSessionConfiguration, completionHandlerQueue: OperationQueue) {
        urlSessionConfiguration.timeoutIntervalForRequest = 1260.0
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
    }
    
    // MARK: - ApiClient
    func execute(request: RequestDelegate, tagName: String, completionHandler: @escaping (Result<[XMLNode], Error>) -> Void) {
        let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(NetworkRequestError(error: error)))
                return
            }
            let successRange = 200...299
            if successRange.contains(httpUrlResponse.statusCode) {
                guard let data = data else {
                    completionHandler(.failure(XMLParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)))
                    return
                }
                let body = XMLCustomParser().getElementsByTagName(data: data, tagName: "soapenv:Body")?.first
                guard let elements = body?.getElementsByTagName(tagName) else {
                    completionHandler(.failure(XMLParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)))
                    return
                }
                if let rawValue = body?.childNodes.first?.attributes["n:result"], let responseResult = ResponseResult(rawValue: rawValue) {
                    if responseResult == .success || responseResult == .occupiedByItself || responseResult == .invalidSession || responseResult == .cancel || responseResult == .occupiedByOther {
                        completionHandler(.success(elements))
                    } else if responseResult == .exclusiveError {
                        completionHandler(.failure(ExclusiveError(responseResult: responseResult, message: responseResult.rawValue)))
                    } 
                } else {
                    completionHandler(.failure(FormatError()))
                }
            } else {
                completionHandler(.failure(ApiError(data: data, httpUrlResponse: httpUrlResponse)))
            }
        }
        dataTask.resume()
    }
}



