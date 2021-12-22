//
//  String+Extensions.swift
//  GlorySDK
//
//  Created by John Kricorian on 22/07/2021.
//

import Foundation

public extension String {
    
    func toInt() -> Int {
        return NumberFormatter().number(from: self)?.intValue ?? 0
    }
    
    func format() -> String {
        guard let price = Int(self) else { return "" }
        return String(format: "%.2f", (Double(price) / 100.0))
    }
}

