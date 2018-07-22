//
//  UIApplication+AppExtensions.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var topMostViewController: UIViewController {
        // See the ongoing discussion: https://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller
        var topViewController = shared.keyWindow?.rootViewController ?? AppDelegate.current.rootViewController
        while let presentedViewController = topViewController.presentedViewController,
            presentedViewController.isBeingPresented == false,
            presentedViewController.isBeingDismissed == false {
                topViewController = presentedViewController
        }
        return topViewController
    }
}
