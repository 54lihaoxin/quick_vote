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
        case hostSession
        case joinSession
        
        static let allCases: [Section] = [hostSession, joinSession]
        
        static func section(for sectionNumber: Int) -> Section {
            guard let section = Section(rawValue: sectionNumber) else {
                fatalError()
            }
            return section
        }
        
        var sectionTitle: String {
            switch self {
            case .hostSession:
                return NSLocalizedString("Host a voting session", comment: "")
            case .joinSession:
                return NSLocalizedString("Join a voting session", comment: "")
            }
        }
    }
    
    fileprivate static let cellReuseIdentifier = "ReuseID"
    
    fileprivate var otherServices: [NetService] = []
    
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
        
        applyAppTheme()
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
        case .hostSession:
            return 1 // +1 for creating a new voting session
        case .joinSession:
            return max(1, otherServices.count) // +1 for default no voting session message
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
        case .hostSession:
            cell.textLabel?.text = NSLocalizedString("Create a new voting session", comment: "")
        case .joinSession:
            if otherServices.isEmpty {
                cell.textLabel?.text = NSLocalizedString("No voting session available now", comment: "")
            } else {
                cell.textLabel?.text = otherServices[indexPath.row].name
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Section.section(for: indexPath.section) {
        case .hostSession:
            let nav = UINavigationController(rootViewController: SessinoHostViewController())
            present(nav, animated: true, completion: nil)
        case .joinSession:
            if otherServices.isEmpty {
                // no op
            } else {
                let nav = UINavigationController(rootViewController: SessinoGuestViewController(hostService: otherServices[indexPath.row]))
                present(nav, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - AppNotificationObserver

extension SessionListViewController: AppNotificationObserver {
    
    func handleNotification(_ notification: Notification) {
        switch notification.name {
        case QuickVoteServiceBrowser.ServiceListUpdateNotification.name:
            print("\(type(of: self)).\(#function)", notification.name)
            otherServices = QuickVoteServiceBrowser.shared.services
            tableView.reloadData()
        default:
            assertionFailure("\(type(of: self)).\(#function) notification is observed but not handled: \(notification.name)")
        }
    }
}

// MARK: - private helpers

private extension SessionListViewController {
    
    func registerNotifications() {
        QuickVoteServiceBrowser.ServiceListUpdateNotification.addObserver(self)
    }
}
