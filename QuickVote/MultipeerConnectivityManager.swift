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
    
    fileprivate static let inviteTimeout: TimeInterval = 30
    fileprivate static let serviceType = "hxl-quickvote" // `serviceType` should be in the same format as a Bonjour service type: up to 15 characters long and valid characters include ASCII lowercase letters, numbers, and the hyphen. A short name that distinguishes itself from unrelated services is recommended.
    
    fileprivate var connectedPeerIDs: [MCPeerID] = []
    
    let peerID: MCPeerID
    private(set) lazy var advertiser: MCNearbyServiceAdvertiser = {
        let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: MultipeerConnectivityManager.serviceType)
        advertiser.delegate = self
        return advertiser
    }()
    private(set) lazy var browser: MCNearbyServiceBrowser = {
        let
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MultipeerConnectivityManager.serviceType)
        browser.delegate = self
        return browser
    }()
    private(set) lazy var session: MCSession = {
        let session = MCSession(peer: peerID)
        session.delegate = self
        return session
    }()
    
    init(with displayName: String) {
        peerID = MCPeerID(displayName: displayName)
        super.init()
    }
}

// MARK: - API

extension MultipeerConnectivityManager {
    
    func start() {
        print("\(#function)", peerID.displayName)
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension MultipeerConnectivityManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("\(#function)")
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("\(#function)")
    }
}

// MARK: - MCNearbyServiceBrowserDelegate

extension MultipeerConnectivityManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("\(#function) \(peerID.displayName)")
        guard self.peerID.hashValue > peerID.hashValue else { // only one peer should send invite
            return
        }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: MultipeerConnectivityManager.inviteTimeout)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("\(#function)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("\(#function)")
    }
}

// MARK: - MCSessionDelegate

extension MultipeerConnectivityManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("\(#function) [\(peerID.displayName)] [state: \(state.rawValue)]")
        switch state {
        case .notConnected:
            if let index = connectedPeerIDs.index(of: peerID) {
                print("\(#function) remove peerID \(peerID.displayName)]")
                connectedPeerIDs.remove(at: index)
            }
        case .connecting:
            break
        case .connected:
            if !connectedPeerIDs.contains(peerID) {
                print("\(#function) add peerID \(peerID.displayName)]")
                connectedPeerIDs.append(peerID)
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

extension MultipeerConnectivityManager {
    
}
