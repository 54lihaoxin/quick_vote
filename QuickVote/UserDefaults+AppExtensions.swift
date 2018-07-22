//
//  UserDefaults+AppExtensions.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private static var keyDisplayName = "displayName"
    
    /// This is the display name of the peer ID.
    var displayName: String? {
        return value(forKey: UserDefaults.keyDisplayName) as? String
    }
    
    func setDisplayName(_ displayName: String) {
        set(displayName, forKey: UserDefaults.keyDisplayName)
    }
}
