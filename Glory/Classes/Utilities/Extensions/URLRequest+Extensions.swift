//
//  URLRequest+Extensions.swift
//  GlorySDK
//
//  Created by John Kricorian on 06/07/2021.
//

import Foundation

public extension URLRequest {
    
    mutating func setHTTPMethod(_ httpMethod: String) {
        self.httpMethod = httpMethod
    }
}
