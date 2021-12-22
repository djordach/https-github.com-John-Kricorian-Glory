//
//  BodyRequest.swift
//  GlorySDK
//
//  Created by John Kricorian on 06/07/2021.
//

import Foundation

 class Request: NSObject {

    private let requestName: String
    private let sessionId: String?
    private let amount: String?
    private let inventoryOption: String?
    private let gloryIP: String?
    private let destination: Destination?
    private let url: String?
    private let IPAddress: String?
    private let month: String?
    private let day: String?
    private let year: String?
    private let hour: String?
    private let minute: String?
    private let second: String?
    private let user: String?
    private let pwd: String?
    
    internal init(parameter: String, sessionId: String? = nil, amount: String? = nil, inventoryOption: String? = nil, gloryIP: String? = nil, destination: Destination? = nil, url: String? = nil, IPAddress: String? = nil, month: String? = nil, day: String? = nil, year: String? = nil, hour: String? = nil, minute: String? = nil, second: String? = nil, user: String? = nil, pwd: String? = nil) {
        self.requestName = parameter
        self.sessionId = sessionId
        self.amount = amount
        self.inventoryOption = inventoryOption
        self.gloryIP = gloryIP
        self.destination = destination
        self.url = url
        self.IPAddress = IPAddress
        self.month = month
        self.day = day
        self.year = year
        self.hour = hour
        self.minute = minute
        self.second = second
        self.user = user
        self.pwd = pwd
    }
    
    var adjustTimeRequest: Data {
        let body = Body(requestName: requestName)
        let url = "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID><Date bru:month=\"\(month ?? "")\" bru:day=\"\(day ?? "")\" bru:year=\"\(year ?? "")\"/><Time bru:hour=\"\(hour ?? "")\" bru:minute=\"\(minute ?? "")\" bru:second=\"\(second ?? "")\"/>\(body.end)"
        print("")
        return url.data(using: .utf8)!
    }
    
    
    var statusRequest: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID><Option bru:type=\"?\"/><!--Optional:--><RequireVerification bru:type=\"1\"/>\(body.end)"
            .data(using: .utf8)!
    }
    
    var openRequest: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<bru:User>\(user ?? "")</bru:User><bru:UserPwd>\(pwd ?? "")</bru:UserPwd><bru:DeviceName>?</bru:DeviceName>\(body.end)"
            .data(using: .utf8)!
    }
    
    var occupyOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID><!--Optional:--><bru:OccupyImg>2</bru:OccupyImg>\(body.end)"
            .data(using: .utf8)!
    }
    
    var releaseOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID>\(body.end)".data(using: .utf8)!
    }
    
    var closeOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID>\(body.end)".data(using: .utf8)!
    }
        
    var changeOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID><bru:Amount>\(amount ?? "")</bru:Amount><!--Optional:--><Option bru:type=\"?\"/><!--Optional:--><Cash bru:type=\"?\" bru:note_destination=\"?\" bru:coin_destination=\"?\"><!--Zero or more repetitions:--><Denomination bru:cc=\"?\" bru:fv=\"?\" bru:rev=\"?\" bru:devid=\"?\"><bru:Piece>?</bru:Piece><bru:Status>?</bru:Status></Denomination></Cash><!--Optional:--><!--<ForeignCurrency bru:cc=\"?\"><Rate>?</Rate></ForeignCurrency>-->\(body.end)".data(using: .utf8)!
    }
    
    var changeCancelOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID><!--Optional:--><Option bru:type=\"?\">\(body.end)".data(using: .utf8)!
    }

    var inventoryOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID><!--Optional:--><Option bru:type=\"\(inventoryOption ?? "")\">\(body.end)".data(using: .utf8)!
    }
    
    var registerEventOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID><bru:Url>\(IPAddress ?? "")</bru:Url><!--Optional:--><bru:Port>10000</bru:Port><!--Optional:--><DestinationType bru:type=\"\(destination?.rawValue ?? "")\"/><!--Optional:--><Encryption bru:type=\"?\"/><!--Optional:--><RequireEventList></RequireEventList>\(body.end)".data(using: .utf8)!
    }
    
    var unregisterEventOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID><bru:Url>\(IPAddress ?? "")</bru:Url><!--Optional:--><bru:Port>10000</bru:Port>\(body.end)".data(using: .utf8)!
    }
    
    var resetOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID>\(body.end)".data(using: .utf8)!
    }
    
    var openExitCoverOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID>\(body.end)".data(using: .utf8)!
    }
    
    var closeExitCoverOperation: Data {
        let body = Body(requestName: requestName)
        return "\(body.start)<!--Optional:--><bru:SessionID>\(sessionId ?? "")</bru:SessionID>\(body.end)".data(using: .utf8)!
    }
}

