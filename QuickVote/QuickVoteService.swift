//
//  QuickVoteService.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation
import UIKit

final class QuickVoteService: NSObject {
    
    static let domain = "local"
    static let type = "_quickvote._tcp"
    static let shared = QuickVoteService()
    
    fileprivate(set) lazy var netService: NetService = {
        let service = NetService(domain: QuickVoteService.domain,
                                 type: QuickVoteService.type,
                                 name: UserDefaults.standard.displayName ?? UIDevice.current.name)
        service.delegate = self
        service.includesPeerToPeer = true
        return service
    }()
    
    
    fileprivate var isNetServicePublished = false
}

// MARK: - API

extension QuickVoteService {
    
    func start() {
        guard isNetServicePublished == false else {
            return
        }
        netService.publish(options: .listenForConnections)
    }
}

// MARK: - NetServiceDelegate

extension QuickVoteService: NetServiceDelegate {
    
    func netServiceWillPublish(_ sender: NetService) {
        print("\(#function)")
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        print("\(#function)")
        isNetServicePublished = true
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("\(#function)")
    }
    
    func netServiceWillResolve(_ sender: NetService) {
        print("\(#function)")
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("\(#function)")
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("\(#function)")
    }
    
    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        print("\(#function)")
    }
    
    func netService(_ sender: NetService, didUpdateTXTRecord data: Data) {
        print("\(#function)")
    }
    
    func netServiceDidStop(_ sender: NetService) {
        print("\(#function)")
        isNetServicePublished = false
    }
}
