//
//  ApiRequests.swift
//  GlorySDK
//
//  Created by John Kricorian on 12/07/2021.
//

import Foundation

protocol RequestDelegate {
    var urlRequest: URLRequest { get }
}

class ClientURL {
    
    let clientIP: String
    
    internal init(clientIP: String) {
        self.clientIP = clientIP
    }
    
    var url: URL {
        let url = URL(string: "http://\(clientIP)/axis2/services/BrueBoxService")!
        return url
    }
}

class AdjustTimeRequest: RequestDelegate {
    
    private let sessionId: String
    private let parameter: RequestParameter
    private let operation: Operation
    private let clientIP: String
    private let year: String
    private let month: String
    private let day: String
    private let hour: String
    private let minute: String
    private let second: String
    
    internal init(sessionId: String, parameter: RequestParameter, operation: Operation, clientIP: String, year: String, month: String, day: String, hour: String, minute: String, second: String) {
        self.sessionId = sessionId
        self.parameter = parameter
        self.operation = operation
        self.clientIP = clientIP
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
    }
    
    var allHTTPHeaderFields = [
        "content-type": "text/xml"
    ]
    
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: parameter.result,
                                   sessionId: sessionId,
                                   month: month,
                                   day: day,
                                   year: year,
                                   hour: hour,
                                   minute: minute,
                                   second: second).adjustTimeRequest
        return request
    }
}

class GetStatusRequest: RequestDelegate {
    
    private let sessionId: String
    private let parameter: RequestParameter
    private let operation: Operation
    private let clientIP: String
    
    internal init(sessionId: String, parameter: RequestParameter, operation: Operation, clientIP: String) {
        self.sessionId = sessionId
        self.parameter = parameter
        self.operation = operation
        self.clientIP = clientIP
    }
    
    var allHTTPHeaderFields = [
        "content-type": "text/xml"
    ]
    
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: parameter.result, sessionId: sessionId).statusRequest
        return request
    }
}


class OpenOperationRequest: RequestDelegate {
    
    private let parameter: RequestParameter
    private let operation: Operation
    private let clientIP: String
    private let user: String
    private let pwd: String
    
    internal init(parameter: RequestParameter, operation: Operation, clientIP: String, user: String, pwd: String) {
        self.parameter = parameter
        self.operation = operation
        self.clientIP = clientIP
        self.user = user
        self.pwd = pwd
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml",
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: parameter.result).openRequest
        return request
    }
}

class OccupyOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let parameter: RequestParameter
    private let operation: Operation
    private let clientIP: String
    
    internal init(sessionId: String, parameter: RequestParameter, operation: Operation, clientIP: String) {
        self.sessionId = sessionId
        self.parameter = parameter
        self.operation = operation
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml"
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: parameter.result,
                                   sessionId: sessionId).occupyOperation
        return request
    }
}

class ChangeOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let amount: String
    private let parameter: RequestParameter
    private let operation: Operation
    private let clientIP: String
    
    internal init(sessionId: String, amount: String, parameter: RequestParameter, operation: Operation, clientIP: String) {
        self.sessionId = sessionId
        self.amount = amount
        self.parameter = parameter
        self.operation = operation
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml"
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: parameter.result,
                                   sessionId: sessionId,
                                   amount: amount).changeOperation
        return request
    }
}

class ReleaseOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let operation: Operation
    private let requestParameter: RequestParameter
    private let clientIP: String
    
    internal init(sessionId: String, operation: Operation, requestParameter: RequestParameter, clientIP: String) {
        self.sessionId = sessionId
        self.operation = operation
        self.requestParameter = requestParameter
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml"
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: requestParameter.result,
                                   sessionId: sessionId).releaseOperation
        return request
    }
}

class CloseOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let operation: Operation
    private let requestParameter: RequestParameter
    private let clientIP: String
    
    internal init(sessionId: String, operation: Operation, requestParameter: RequestParameter, clientIP: String) {
        self.sessionId = sessionId
        self.operation = operation
        self.requestParameter = requestParameter
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml",
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: requestParameter.result,
                                   sessionId: sessionId).closeOperation
        return request
    }
}

class CancelOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let operation: Operation
    private let requestParameter: RequestParameter
    private let clientIP: String
    
    internal init(sessionId: String, operation: Operation, requestParameter: RequestParameter, clientIP: String) {
        self.sessionId = sessionId
        self.operation = operation
        self.requestParameter = requestParameter
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml",
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: requestParameter.result,
                                   sessionId: sessionId).changeCancelOperation
        return request
    }
}

class RegisterEventOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let operation: Operation
    private let requestParameter: RequestParameter
    private let destination: Destination
    private let clientIP: String
    
    internal init(sessionId: String, operation: Operation, requestParameter: RequestParameter, destination: Destination, clientIP: String) {
        self.sessionId = sessionId
        self.operation = operation
        self.requestParameter = requestParameter
        self.destination = destination
        self.clientIP = clientIP
    }
        
    private var allHTTPHeaderFields = [
        "content-type": "text/xml",
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: requestParameter.result,
                                   sessionId: sessionId,
                                   destination: destination,
                                   IPAddress: Host().IPAddress()).registerEventOperation
        return request
    }
}

class UnRegisterEventOperationRequest: RequestDelegate {
    
    private let operation: Operation
    private let requestParameter: RequestParameter
    private let id: String
    private let sessionId: String
    private let clientIP: String

    internal init(operation: Operation, requestParameter: RequestParameter, id: String, sessionId: String, clientIP: String) {
        self.operation = operation
        self.requestParameter = requestParameter
        self.id = id
        self.sessionId = sessionId
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml",
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: requestParameter.result,
                                   sessionId: sessionId,
                                   IPAddress: Host().IPAddress()).unregisterEventOperation
        return request
    }
}

class InventoryOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let operation: Operation
    private let requestParameter: RequestParameter
    private let inventoryOption: String
    private let clientIP: String
    
    internal init(sessionId: String, operation: Operation, requestParameter: RequestParameter, inventoryOption: String, clientIP: String) {
        self.sessionId = sessionId
        self.operation = operation
        self.requestParameter = requestParameter
        self.inventoryOption = inventoryOption
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml",
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: requestParameter.result,
                                   sessionId: sessionId,
                                   inventoryOption: inventoryOption).inventoryOperation
        return request
    }
}

class ResetOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let operation: Operation
    private let requestParameter: RequestParameter
    private let clientIP: String
    
    internal init(sessionId: String, operation: Operation, requestParameter: RequestParameter, clientIP: String) {
        self.sessionId = sessionId
        self.operation = operation
        self.requestParameter = requestParameter
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml",
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: requestParameter.result,
                                   sessionId: sessionId).resetOperation
        return request
    }
}

class OpenExitCoverOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let operation: Operation
    private let requestParameter: RequestParameter
    private let clientIP: String
    
    internal init(sessionId: String, operation: Operation, requestParameter: RequestParameter, clientIP: String) {
        self.sessionId = sessionId
        self.operation = operation
        self.requestParameter = requestParameter
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml",
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: requestParameter.result,
                                   sessionId: sessionId).openExitCoverOperation
        return request
    }
}

class CloseExitCoverOperationRequest: RequestDelegate {
    
    private let sessionId: String
    private let operation: Operation
    private let requestParameter: RequestParameter
    private let clientIP: String
    
    internal init(sessionId: String, operation: Operation, requestParameter: RequestParameter, clientIP: String) {
        self.sessionId = sessionId
        self.operation = operation
        self.requestParameter = requestParameter
        self.clientIP = clientIP
    }
    
    private var allHTTPHeaderFields = [
        "content-type": "text/xml",
    ]
            
    var urlRequest: URLRequest {
        let url = ClientURL(clientIP: clientIP).url
        var request = URLRequest(url: url)
        request.setHTTPMethod("POST")
        allHTTPHeaderFields.updateValue(operation.name, forKey: "SOAPAction")
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = Request(parameter: requestParameter.result,
                                   sessionId: sessionId).closeExitCoverOperation
        return request
    }
}


