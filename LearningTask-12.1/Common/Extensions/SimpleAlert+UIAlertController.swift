//
//  Alert+UIViewController.swift
//  LearningTask-12.1
//
//  Created by rafael.rollo on 03/08/2022.
//

import UIKit

extension UIAlertController {
    
    static func showError(_ message: String,
                          in topViewController: UIViewController,
                          completion: (() -> Void)? = nil) {
        let title = "Erro"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancel)
        
        topViewController.present(alert, animated: true, completion: completion)
    }
    
}

extension UIViewController {
    
    func alertError(_ message: String, completion: (() -> Void)? = nil) {
        UIAlertController.showError(message, in: self, completion: completion)
    }
    
}
