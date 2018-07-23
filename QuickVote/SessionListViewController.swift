//
//  SessionListViewController.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import MultipeerConnectivity
import UIKit

final class SessionListViewController: UIViewController {
    
    fileprivate enum Section: Int, CaseIterable {
        case host
        case guest
        //case browser // TODO:
        
        static let allCases: [Section] = [host, guest]
        
        static func section(for sectionNumber: Int) -> Section {
            guard let section = Section(rawValue: sectionNumber) else {
                fatalError()
            }
            return section
        }
        
        var sectionTitle: String {
            switch self {
            case .host:
                return NSLocalizedString("Host a voting session", comment: "")
            case .guest:
                return NSLocalizedString("Join a voting session", comment: "")
            }
        }
    }
    
    fileprivate static let cellReuseIdentifier = "ReuseID"
    
    fileprivate var hostPeerIDs: [MCPeerID] = []
    
    fileprivate lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.dataSource = self
        tv.delegate = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: SessionListViewController.cellReuseIdentifier)
        return tv
    }()
    
    override func loadView() {
        super.loadView()
        
        title = NSLocalizedString("Quick Vote", comment: "")
        view.addSubview(tableView)
        tableView.activateLayoutAnchorsWithSuperView()
        
        registerNotifications()
    }
}

// MARK: - UITableViewDataSource

extension SessionListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.section(for: section) {
        case .host:
            return 1 // +1 for creating a new voting session
        case .guest:
            return hostPeerIDs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SessionListViewController.cellReuseIdentifier, for: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension SessionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.section(for: section).sectionTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch Section.section(for: indexPath.section) {
        case .host:
            cell.textLabel?.text = NSLocalizedString("Create a new voting session", comment: "")
        case .guest:
            cell.textLabel?.text = hostPeerIDs[indexPath.row].displayName
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AppNotificationObserver

extension SessionListViewController: AppNotificationObserver {
    
    func handleNotification(_ notification: Notification) {
        switch notification.name {
        case MultipeerConnectivityManager.PeerDiscoveryUpdateNotification.name:
            print("handleNotification", notification)
            hostPeerIDs = AppDelegate.current.multipeerConnectivityManager?.hostPeerIDs ?? []
            tableView.reloadData()
        default:
            assertionFailure("\(#function) notification is observed but not handled: \(notification.name)")
        }
    }
}

// MARK: - private helpers

private extension SessionListViewController {
    
    func registerNotifications() {
        MultipeerConnectivityManager.PeerDiscoveryUpdateNotification.addObserver(self)
    }
}
