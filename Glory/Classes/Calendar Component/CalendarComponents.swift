//
//  CalendarComponents.swift
//  GloryFramework
//
//  Created by John Kricorian on 21/12/2021.
//

import Foundation

class CalendarComponent {
    
    let sessionId: String?
    let clientIP: String

    internal init(sessionId: String?, clientIP: String) {
        self.sessionId = sessionId
        self.clientIP = clientIP
    }
    
    internal var adjustTimeRequest: AdjustTimeRequest {
        return AdjustTimeRequest(sessionId: sessionId ?? "",
                                        parameter: .adjustTime,
                                        operation: .adjustTime,
                                        clientIP: clientIP,
                                        year: calendarComponents["year"] ?? "",
                                        month: calendarComponents["month"] ?? "",
                                        day: calendarComponents["day"] ?? "",
                                        hour: calendarComponents["hour"] ?? "",
                                        minute: calendarComponents["minute"] ?? "",
                                        second: calendarComponents["second"] ?? "")
    }
    
    private var calendarComponents: [String:String] {
        let date = Date()
        let calendar = Calendar.current
        
        var calendarComponents: [String:String] = [:]
        calendarComponents["year"] = String(calendar.component(.year, from: date))
        calendarComponents["month"] = String(calendar.component(.month, from: date))
        calendarComponents["day"] = String(calendar.component(.day, from: date))
        calendarComponents["hour"] = String(calendar.component(.hour, from: date))
        calendarComponents["minute"] = String(calendar.component(.minute, from: date))
        calendarComponents["second"] = String(calendar.component(.second, from: date))
        
        return calendarComponents
    }
}
