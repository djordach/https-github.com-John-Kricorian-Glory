//
//  Status.swift
//  GloryFramework
//
//  Created by John Kricorian on 09/11/2021.
//

import Foundation

@objc public class Status: NSObject {
    
     public var statusCode: StatusCode
     @objc public var billDevStatus: DeviceStatus
     @objc public var coinDevStatus: DeviceStatus
     public var emptyMoneyItems: [MoneyItem]?
     public var isFlaggedStacker: Bool
     public var error: Error?
    
    public init(statusCode: StatusCode = .unknown, billDevStatus: DeviceStatus = .state_idle, coinDevStatus: DeviceStatus = .state_idle, emptyMoneyItems: [MoneyItem]? = nil, error: Error? = nil, isFlaggedStatus: Bool = false) {
        self.statusCode = statusCode
        self.billDevStatus = billDevStatus
        self.coinDevStatus = coinDevStatus
        self.emptyMoneyItems = emptyMoneyItems
        self.error = error
        self.isFlaggedStacker = isFlaggedStatus
    }
    
    public func getAlerts() -> [Alert] {
        var alerts: [Alert] = []
        guard let emptyMoneyItems = emptyMoneyItems else { return [] }
        for emptyMoneyItem in emptyMoneyItems {
            let alert = Alert(denomination: emptyMoneyItem.facialValue + " " +  emptyMoneyItem.currency, status: emptyMoneyItem.status.rawValue)
            alerts.append(alert)
        }
        if coinDevStatus != .state_idle {
            let alert = Alert(denomination: "CI-10B", status: coinDevStatus.rawValue)
            alerts.append(alert)
        }
        if billDevStatus != .state_idle{
            let alert = Alert(denomination: "CI-10C", status: billDevStatus.rawValue)
            alerts.append(alert)
        }
        return alerts
    }
}

public class Alert {
    public var denomination: String
    public var status: String
    
    internal init(denomination: String, status: String) {
        self.denomination = denomination
        self.status = status
    }
}
