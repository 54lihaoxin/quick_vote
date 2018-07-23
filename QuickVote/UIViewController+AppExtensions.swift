//
//  UIViewController+AppExtensions.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func applyAppTheme() {
        if let navigationController = navigationController {
            navigationController.navigationBar.barTintColor = .appTint
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
}
