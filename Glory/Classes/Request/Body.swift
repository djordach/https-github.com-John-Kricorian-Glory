//
//  Body.swift
//  GlorySDK
//
//  Created by John Kricorian on 19/07/2021.
//

import Foundation

 class Body: NSObject {
    
    var requestName: String
    
    internal init(requestName: String) {
        self.requestName = requestName
    }
        
    var start: String {
        return "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:bru=\"http://www.glory.co.jp/bruebox.xsd\"><soapenv:Header/><soapenv:Body><bru:\(requestName)><!--Optional:--><bru:Id>?</bru:Id><bru:SeqNo>?</bru:SeqNo>"
    }
    
    var end: String {
        return "</bru:\(requestName)></soapenv:Body></soapenv:Envelope>"
    }
}
