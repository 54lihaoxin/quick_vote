//
//  SessinoHostViewController.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class SessinoHostViewController: UIViewController {

    override func loadView() {
        super.loadView()
        
        title = NSLocalizedString("Session Host", comment: "")
        if navigationItem.leftBarButtonItem == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Quit", comment: ""),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(quitHostingSession))
        }
        
        QuickVoteService.shared.start()
    }
}

// MARK: - private helpers

private extension SessinoHostViewController {
    
    @objc func quitHostingSession() {
        QuickVoteService.shared.stop()
        dismiss(animated: true, completion: nil)
    }
}
