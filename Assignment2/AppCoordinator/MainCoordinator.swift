//
//  MainCoordinator.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import UIKit

class MainCoordinator : Coordinator {
    
    var navigationController: UINavigationController
    
    init(with _navigationController: UINavigationController) {
        navigationController = _navigationController
    }
    
    func configureRootViewController() {
        let loginVC = LoginViewController()
        loginVC.mainCoordinator = self
        self.navigationController.pushViewController(loginVC, animated: false)
    }
    
    func navigateToSignUpVC() {
        let signUpVC = SignupViewController()
        signUpVC.mainCoordinator = self
        self.navigationController.present(signUpVC, animated: true, completion: nil)
    }
    
    func navigateToHomeVC(companyName: String) {
        let homeVC = EmployeeListViewController()
        homeVC.fileName = companyName
        self.navigationController.pushViewController(homeVC, animated: true)
    }
    
    func dismissVC() {
        self.navigationController.dismiss(animated: true, completion: nil)
    }
}
