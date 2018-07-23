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
    let rootViewController = UINavigationController(rootViewController: SessionListViewController())
    
    static var current: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("\(#function) application delegate is not `AppDelegate`")
        }
        return delegate
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        if let displayName = UserDefaults.standard.displayName, !displayName.isEmpty {
            QuickVoteServiceBrowser.shared.start()
        } else { // first app launch without display name
            UIAlertController.showUserNameInputAlert(defaultValue: UIDevice.current.name) { newName in
                UserDefaults.standard.setDisplayName(newName)
                QuickVoteServiceBrowser.shared.start()
            }
        }
    }
}
