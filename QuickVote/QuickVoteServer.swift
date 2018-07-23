//
//  QuickVoteServer.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation
import UIKit

final class QuickVoteServer: NSObject {
    
    static let domain = "local"
    static let typeID = "_quickvote._tcp"
    static let shared = QuickVoteServer()
    
    fileprivate(set) lazy var netService: NetService = {
        let service = NetService(domain: QuickVoteServer.domain,
                                 type: QuickVoteServer.typeID,
                                 name: UserDefaults.standard.displayName ?? UIDevice.current.name)
        service.delegate = self
        service.includesPeerToPeer = true
        return service
    }()
    
    fileprivate var isNetServicePublished = false
    fileprivate var serviceIO: QuickVoteServiceIO?
    
    deinit {
        serviceIO?.closeSteams()
    }
}

// MARK: - API

extension QuickVoteServer {
    
    func start() {
        guard isNetServicePublished == false else {
            return
        }
        netService.publish(options: .listenForConnections)
    }
    
    func stop() {
        netService.stop()
    }
}

// MARK: - NetServiceDelegate

extension QuickVoteServer: NetServiceDelegate {
    
    func netServiceWillPublish(_ sender: NetService) {
        print("\(type(of: self)).\(#function)")
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        print("\(type(of: self)).\(#function)")
        isNetServicePublished = true
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("\(type(of: self)).\(#function)")
    }
    
    func netServiceWillResolve(_ sender: NetService) {
        print("\(type(of: self)).\(#function)")
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("\(type(of: self)).\(#function)")
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("\(type(of: self)).\(#function)")
    }
    
    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        print("\(type(of: self)).\(#function)", inputStream, outputStream)
        guard sender == netService else {
            assertionFailure("\(type(of: self)).\(#function) sender is not `netService`")
            return
        }
        // The input stream and output stream are the same for different accepted client connections
        let serviceIO = QuickVoteServiceIO(inputStream: inputStream, outputStream: outputStream)
        self.serviceIO = serviceIO
        serviceIO.openStreams()
    }
    
    func netService(_ sender: NetService, didUpdateTXTRecord data: Data) {
        print("\(type(of: self)).\(#function)")
    }
    
    func netServiceDidStop(_ sender: NetService) {
        print("\(type(of: self)).\(#function)")
        isNetServicePublished = false
    }
}
