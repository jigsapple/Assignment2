//
//  UIViewController+Extension.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import UIKit

extension UIViewController {
  
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
