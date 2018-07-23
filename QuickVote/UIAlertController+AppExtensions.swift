//
//  UIAlertController+AppExtensions.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func showUserNameInputAlert(defaultValue: String, newNameHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: NSLocalizedString("What is your name?", comment: ""),
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = defaultValue
            textField.text = defaultValue
        }
        
        let actionHandler: (UIAlertAction) -> Void = { _ in
            guard let nameInputField = alert.textFields?.first else {
                assertionFailure("\(type(of: self)).\(#function) name input field is missing")
                newNameHandler(defaultValue)
                return
            }
            guard let newName = nameInputField.text, !newName.isEmpty else {
                newNameHandler(defaultValue)
                return
            }
            newNameHandler(newName)
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: actionHandler))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: actionHandler))
        alert.show()
    }
    
    func show() {
        UIApplication.topMostViewController.present(self, animated: true, completion: nil)
    }
}
