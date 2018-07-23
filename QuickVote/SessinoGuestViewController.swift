//
//  SessinoGuestViewController.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class SessinoGuestViewController: UIViewController {
    
    fileprivate let host: NetService

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(host: NetService) {
        self.host = host
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
    }
}

// MARK: - private helpers

private extension SessinoGuestViewController {
    
    @objc func quitSession() {
        dismiss(animated: true, completion: nil)
    }
}
