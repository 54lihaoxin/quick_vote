//
//  SessinoHostViewController.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class SessinoHostViewController: UIViewController {
    
    fileprivate let serviceIO = QuickVoteServiceClient(host: QuickVoteServer.shared.netService)

    override func loadView() {
        super.loadView()
        
        title = NSLocalizedString("Session Host", comment: "")
        if navigationItem.leftBarButtonItem == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Quit", comment: ""),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(quitSession))
        }
        
        applyAppTheme()
        QuickVoteServer.shared.start()
        serviceIO.start()
    }
}

// MARK: - private helpers

private extension SessinoHostViewController {
    
    @objc func quitSession() {
        QuickVoteServer.shared.stop()
        dismiss(animated: true, completion: nil)
    }
}
