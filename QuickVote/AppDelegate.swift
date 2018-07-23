//
//  AppDelegate.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/16/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)
    let rootViewController: UINavigationController = {
        let nav = UINavigationController(rootViewController: SessionListViewController())
        nav.navigationBar.barTintColor = .appTint
        nav.navigationBar.tintColor = .white
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        return nav
    }()
    private(set) var multipeerConnectivityManager: MultipeerConnectivityManager?
    
    static var current: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("\(#function) application delegate is not `AppDelegate`")
        }
        return delegate
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        QuickVoteService.shared.start()
        
//        if let displayName = UserDefaults.standard.displayName {
//            let manager = MultipeerConnectivityManager(with: displayName)
//            multipeerConnectivityManager = manager
//            manager.startBrowsingForPeers()
//        } else { // first app launch without display name
//            UIAlertController.showUserNameInputAlert(defaultValue: UIDevice.current.name) { [weak self] newName in
//                UserDefaults.standard.setDisplayName(newName)
//                let manager = MultipeerConnectivityManager(with: newName)
//                self?.multipeerConnectivityManager = manager
//                manager.startBrowsingForPeers()
//            }
//        }
    }
}
