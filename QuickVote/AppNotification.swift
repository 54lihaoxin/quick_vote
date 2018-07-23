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
    var name: Notification.Name { get }
}

@objc protocol AppNotificationObserver {
    func handleNotification(_ notification: Notification)
}

extension AppNotification {
    
    static var name: Notification.Name {
        return Notification.Name(rawValue: "\(type(of: self))")
    }
    
    var name: Notification.Name {
        return Self.name
    }
    
    static func appNotification(from notification: Notification) -> Self? {
        guard let appNotification = notification.object as? Self else {
            return nil
        }
        return appNotification
    }
    
    static func addObserver(_ observer: AppNotificationObserver) {
        NotificationCenter.default.addObserver(observer, selector: #selector(AppNotificationObserver.handleNotification(_:)), name: Self.name, object: nil)
    }

    func post() {
        NotificationCenter.default.post(name: Self.name, object: self)
    }
}
