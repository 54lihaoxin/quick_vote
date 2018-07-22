//
//  SessionListViewController.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

class SessionListViewController: UIViewController {
    
    fileprivate enum Section: Int, CaseIterable {
        case host
        case guest
        
        static let allCases: [Section] = [host, guest]
        
        static func section(for sectionNumber: Int) -> Section {
            guard let section = Section(rawValue: sectionNumber) else {
                fatalError()
            }
            return section
        }
        
        var sectionTitle: String {
            switch self {
            case .host:
                return NSLocalizedString("Host a voting session", comment: "")
            case .guest:
                return NSLocalizedString("Join a voting session", comment: "")
            }
        }
    }
    
    fileprivate static let cellReuseIdentifier = "ReuseID"
    
    fileprivate lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.dataSource = self
        tv.delegate = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: SessionListViewController.cellReuseIdentifier)
        return tv
    }()
    
    override func loadView() {
        super.loadView()
        
        title = NSLocalizedString("Quick Vote", comment: "")
        view.addSubview(tableView)
        tableView.activateLayoutAnchorsWithSuperView()
    }
}

extension SessionListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.section(for: section) {
        case .host:
            return 1 // TODO:
        case .guest:
            return 0 // TODO:
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: SessionListViewController.cellReuseIdentifier, for: indexPath)
    }
}

extension SessionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.section(for: section).sectionTitle
    }
}
