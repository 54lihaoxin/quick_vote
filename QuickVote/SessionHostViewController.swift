//
//  SessionHostViewController.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import MultipeerConnectivity
import UIKit

final class SessionHostViewController: UIViewController {

    fileprivate let multipeerConnectivityManager: MultipeerConnectivityManager
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(multipeerConnectivityManager: MultipeerConnectivityManager) {
        self.multipeerConnectivityManager = multipeerConnectivityManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        if navigationItem.leftBarButtonItem == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Quit", comment: ""),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(quitHostingSession))
        }
        
        multipeerConnectivityManager.startHostingSession()
    }
}

private extension SessionHostViewController {
    
    @objc func quitHostingSession() {
        multipeerConnectivityManager.quitHostingSession()
        dismiss(animated: true, completion: nil)
    }
}
