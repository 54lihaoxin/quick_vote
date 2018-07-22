//
//  AppDelegate.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/16/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)
    let mainViewController: UINavigationController = {
        let nav = UINavigationController(rootViewController: SessionListViewController())
        nav.navigationBar.barTintColor = .appTint
        nav.navigationBar.tintColor = .white
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        return nav
    }()
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
        MultipeerConnectivityManager.shared.start()
    }
}
