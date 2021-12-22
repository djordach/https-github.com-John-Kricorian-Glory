//
//  MoneyItem.swift
//  GloryFramework
//
//  Created by John Kricorian on 16/09/2021.
//

import Foundation

 public class MoneyItem: NSObject {
    
    internal init(facialValue: String, devid: String, currency: String, piece: String, status: InventoryStatus) {
        self.facialValue = facialValue
        self.devid = devid
        self.currency = currency
        self.status = status
        self.piece = piece
    }
    
    public let facialValue: String
    public let devid: String
    public let currency: String
    public let piece: String
    public let status: InventoryStatus
    
    public func isNearEmpty() -> Bool {
        status == .empty || status == .nearEmpty ? true : false
    }
}


