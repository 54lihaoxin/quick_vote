//
//  QuickVoteServiceBrowser.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation

final class QuickVoteServiceBrowser: NSObject {
    
    struct ServiceListUpdateNotification: AppNotification {
        let service: NetService
    }
    
    static let shared = QuickVoteServiceBrowser()
    
    fileprivate lazy var browser: NetServiceBrowser = {
        let browser = NetServiceBrowser()
        browser.delegate = self
        browser.includesPeerToPeer = true
        return browser
    }()
    
    private(set) var services: [NetService] = []
    
    fileprivate func addService(_ service: NetService) {
        guard service != QuickVoteService.shared.netService else {
            return
        }
        services.append(service)
        ServiceListUpdateNotification(service: service).post()
    }
    
    fileprivate func removeService(_ service: NetService) {
        guard let index = services.index(of: service) else {
            return
        }
        services.remove(at: index)
        ServiceListUpdateNotification(service: service).post()
    }
}

// MARK: - API

extension QuickVoteServiceBrowser {
    
    func start() {
        browser.searchForServices(ofType: QuickVoteService.type, inDomain: QuickVoteService.domain)
    }
    
    func stop() {
        browser.stop()
        services.removeAll()
    }
}

// MARK: - NetServiceBrowserDelegate

extension QuickVoteServiceBrowser: NetServiceBrowserDelegate {
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("\(#function)")
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("\(#function)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print("\(#function)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        print("\(#function)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("\(#function)")
        addService(service)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
        print("\(#function)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        print("\(#function)")
        removeService(service)
    }
}
