//
//  AppNotification.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation

protocol AppNotification {
    static var name: Notification.Name { get }
}

@objc protocol AppNotificationObserver {
    func handleNotification(_ notification: Notification)
}

extension AppNotification {
    
    static var name: Notification.Name {
        return Notification.Name(rawValue: "\(type(of: self))")
    }
    
    static func addObserver(_ observer: AppNotificationObserver, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: #selector(AppNotificationObserver.handleNotification(_:)), name: Self.name, object: object)
    }

    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: Self.name, object: object)
    }
}
