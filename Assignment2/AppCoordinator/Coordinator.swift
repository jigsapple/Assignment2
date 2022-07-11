//
//  Coordinator.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func configureRootViewController()
}
