//
//  SessinoGuestViewController.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class SessinoGuestViewController: UIViewController {
    
    fileprivate let hostService: NetService
    fileprivate let client: QuickVoteClient

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(host: NetService) {
        hostService = host
        client = QuickVoteClient(host: host)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        title = NSLocalizedString("Joined Session", comment: "")
        if navigationItem.leftBarButtonItem == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Quit", comment: ""),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(quitSession))
        }
        
        applyAppTheme()
        registerNotifications()
        client.start()
    }
}

// MARK: - AppNotificationObserver

extension SessinoGuestViewController: AppNotificationObserver {
    
    func handleNotification(_ notification: Notification) {
        if let appNotification = QuickVoteServiceBrowser.ServiceListUpdateNotification.appNotification(from: notification) {
            print("\(type(of: self)).\(#function)", appNotification.name)
            if !QuickVoteServiceBrowser.shared.services.contains(hostService) {
                quitSession() // TODO: show user friendly message
            }
        } else {
            assertionFailure("\(type(of: self)).\(#function) notification is observed but not handled: \(notification.name)")
        }
    }
}

// MARK: - private helpers

private extension SessinoGuestViewController {
    
    @objc func quitSession() {
        dismiss(animated: true, completion: nil)
    }
    
    func registerNotifications() {
        QuickVoteServiceBrowser.ServiceListUpdateNotification.addObserver(self)
    }
}
