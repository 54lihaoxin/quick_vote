//
//  Protocols.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation

/// https://github.com/apple/swift-evolution/blob/master/proposals/0194-derived-collection-of-enum-cases.md
protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: AllCases { get }
}
