//
//  MultipeerConnectivityManager.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/16/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation
import MultipeerConnectivity

final class MultipeerConnectivityManager: NSObject {
    var advertisers: [MCNearbyServiceAdvertiser] = []
    
    
    typealias DiscoveryInfoDictionary = [String: String]
    
    fileprivate struct DiscoveryInfo {
        let mode: Mode
        
        init(mode: Mode) {
            self.mode = mode
        }
        
        init(dictionary: DiscoveryInfoDictionary) {
            guard let modeString = dictionary["mode"], let mode = Mode(rawValue: modeString) else {
                fatalError("\(#function) fail to parse for `mode`")
            }
            self.mode = mode
        }
        
        var dictionary: MultipeerConnectivityManager.DiscoveryInfoDictionary {
            return ["mode": mode.rawValue]
        }
    }
    
    fileprivate enum Mode: String {
        case browser // browse votes
        case host // create a vote
        case guest // join a vote
        case inactive
    }
    
    struct PeerDiscoveryUpdateNotification: AppNotification {
        let peerID: MCPeerID
    }
    
    fileprivate static let inviteTimeout: TimeInterval = 30
    fileprivate static let serviceType = "hxl-quickvote" // `serviceType` should be in the same format as a Bonjour service type: up to 15 characters long and valid characters include ASCII lowercase letters, numbers, and the hyphen. A short name that distinguishes itself from unrelated services is recommended.
    
    fileprivate var mode = Mode.inactive
    fileprivate var discoveredPeerInfo: [MCPeerID: DiscoveryInfo] = [:]
    fileprivate var connectedPeerIDs: Set<MCPeerID> = []
    fileprivate var k_peerID_vs_v_session: [MCPeerID: MCSession] = [:]
    
    fileprivate var advertiser: MCNearbyServiceAdvertiser?
    fileprivate lazy var browser: MCNearbyServiceBrowser = {
        let
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MultipeerConnectivityManager.serviceType)
        browser.delegate = self
        return browser
    }()
    
    let peerID: MCPeerID
    
    var hostPeerIDs: [MCPeerID] {
        return discoveredPeerInfo.compactMap {
            guard let discoveryInfo = discoveredPeerInfo[$0.key] else {
                return nil
            }
            switch discoveryInfo.mode {
            case .host:
                return $0.key
            case .browser, .guest, .inactive:
                return nil
            }
        }
    }
    
    init(with displayName: String) {
        peerID = MCPeerID(displayName: displayName)
        super.init()
    }
}

// MARK: - API

extension MultipeerConnectivityManager {
    
    func startBrowsingForPeers() {
        print("\(#function)", peerID.displayName)
        updateMode(.browser)
    }
    
    func startHostingSession() {
        print("\(#function)", peerID.displayName)
        updateMode(.host)
    }
    
    func quitHostingSession() {
        print("\(#function)", peerID.displayName)
        updateMode(.browser)
    }
    
    
    func advertiseAsGuest() {
        for i in 0...20 {
            let peerID = MCPeerID(displayName: "\(UserDefaults.standard.displayName ?? "SomeName")-\(i)")
            let advertiser = MCNearbyServiceAdvertiser(peer: peerID,
                                                       discoveryInfo: DiscoveryInfo(mode: mode).dictionary,
                                                       serviceType: MultipeerConnectivityManager.serviceType)
            advertiser.startAdvertisingPeer()
            advertisers.append(advertiser)
        }
    }
    
    func disconnect() {
        let s = session(for: peerID)
        s.disconnect()
        mode = .browser
        self.advertiser?.stopAdvertisingPeer()
        let advertiser = MCNearbyServiceAdvertiser(peer: peerID,
                                                   discoveryInfo: DiscoveryInfo(mode: mode).dictionary,
                                                   serviceType: MultipeerConnectivityManager.serviceType)
        self.advertiser = advertiser
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension MultipeerConnectivityManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("\(#function)")
        invitationHandler(true, session(for: peerID))
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("\(#function)")
    }
}

// MARK: - MCNearbyServiceBrowserDelegate

extension MultipeerConnectivityManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        print("\(#function) \(peerID.displayName)", info ?? [:])
        guard let info = info else {
            assertionFailure("\(#function) discovery info is nil")
            return
        }
        let discoveryInfo = DiscoveryInfo(dictionary: info)
        discoveredPeerInfo[peerID] = discoveryInfo
//        if mode == .host, discoveryInfo.mode == .guest { // host invite guest
            browser.invitePeer(peerID, to: session(for: peerID), withContext: nil, timeout: MultipeerConnectivityManager.inviteTimeout)
//        }
        PeerDiscoveryUpdateNotification(peerID: peerID).post()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("\(#function)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("\(#function)", peerID)
        discoveredPeerInfo.removeValue(forKey: peerID)
        PeerDiscoveryUpdateNotification(peerID: peerID).post()
    }
}

// MARK: - MCSessionDelegate

extension MultipeerConnectivityManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("\(#function) [\(peerID.displayName)] [state: \(state.rawValue)]")
        switch state {
        case .notConnected:
            if connectedPeerIDs.contains(peerID) {
                print("\(#function) remove peerID \(peerID.displayName)]")
                connectedPeerIDs.remove(peerID)
            }
        case .connecting:
            break
        case .connected:
            if !connectedPeerIDs.contains(peerID) {
                print("\(#function) add peerID \(peerID.displayName)]")
                connectedPeerIDs.insert(peerID)
                do {
                    try session.send(NSKeyedArchiver.archivedData(withRootObject: "Hello"), toPeers: [peerID], with: .reliable)
                } catch {
                    print("\(#function) error \(error)")
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("\(#function)")
        guard let message = NSKeyedUnarchiver.unarchiveObject(with: data) as? String else {
            print("\(#function) no string data")
            return
        }
        print("\(#function) received message [\(message)]")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("\(#function)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("\(#function)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("\(#function)")
    }
}

// MARK: - private helpers

private extension MultipeerConnectivityManager {
    
    func updateMode(_ mode: Mode) {
        print("\(#function)", mode) // TODO:
        
        guard self.mode != mode else {
            return
        }
        
        advertiser?.stopAdvertisingPeer()
        advertiser = nil
        
        switch self.mode { // session specific handling
        case .host:
            for session in k_peerID_vs_v_session.values {
                session.disconnect()
            }
            k_peerID_vs_v_session.removeAll()
        case .browser, .guest, .inactive:
            break
        }
        
        self.mode = mode
        
        switch mode { // advertiser specific handling
        case .browser, .host, .guest:
            let advertiser = MCNearbyServiceAdvertiser(peer: peerID,
                                                       discoveryInfo: DiscoveryInfo(mode: mode).dictionary,
                                                       serviceType: MultipeerConnectivityManager.serviceType)
            self.advertiser = advertiser
            advertiser.delegate = self
            advertiser.startAdvertisingPeer()
        case .inactive:
            break
        }
        
        switch mode { // browser specific handling
        case .browser, .host, .guest:
            browser.startBrowsingForPeers()
        case .inactive:
            browser.stopBrowsingForPeers()
        }
    }
    
    func session(for peerID: MCPeerID) -> MCSession {
        if let existedSession = k_peerID_vs_v_session[peerID] {
            return existedSession
        } else {
            let session = MCSession(peer: peerID)
            session.delegate = self
            k_peerID_vs_v_session[peerID] = session
            return session
        }
    }
}
