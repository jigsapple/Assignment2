//
//  LoginViewController.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    //Create Login title
    lazy var lblLoginTitle : UILabel = {
        let label = UILabel()
        label.text = "LOGIN"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 42)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Create textfield
    lazy var txtEmailId:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter EmailId"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //Create textfield
    lazy var txtPassword :UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //Create Login button
    lazy var btnLogin : UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnLoginTapped), for: .touchUpInside)
        return btn
    }()
    
    //Create Instruction lable
    lazy var lblInfo : UILabel = {
        let label = UILabel()
        label.text = "if you don't have account then click here"
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Create Login button
    lazy var btnCreateAccount : UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Account", for: .normal)
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnCreateAccountTapped), for: .touchUpInside)
        return btn
    }()
    
    var bag = DisposeBag()
    private let viewModel = LoginViewModel()
    weak var mainCoordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        createObservables()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(lblLoginTitle)
        self.view.addSubview(txtEmailId)
        self.view.addSubview(txtPassword)
        self.view.addSubview(lblInfo)
        self.view.addSubview(btnLogin)
        self.view.addSubview(btnCreateAccount)
        
        NSLayoutConstraint.activate([
            lblLoginTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 50),
            lblLoginTitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -50),
            lblLoginTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 150),
            txtEmailId.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            txtEmailId.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            txtEmailId.topAnchor.constraint(equalTo: lblLoginTitle.bottomAnchor,constant: 50),
            txtPassword.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            txtPassword.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            txtPassword.topAnchor.constraint(equalTo: txtEmailId.bottomAnchor,constant: 20),
            btnLogin.topAnchor.constraint(equalTo: txtPassword.bottomAnchor,constant: 40),
            btnLogin.widthAnchor.constraint(equalTo: txtEmailId.widthAnchor),
            btnLogin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            btnLogin.heightAnchor.constraint(equalToConstant: 50),
            lblInfo.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            lblInfo.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            lblInfo.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 40),
            lblInfo.heightAnchor.constraint(equalToConstant: 30),
            btnCreateAccount.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            btnCreateAccount.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            btnCreateAccount.topAnchor.constraint(equalTo: lblInfo.bottomAnchor, constant: 15),
            btnCreateAccount.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    private func createObservables() {
        
        txtEmailId.rx.text.map({$0 ?? ""}).bind(to: viewModel.email).disposed(by: bag)
        txtPassword.rx.text.map({$0 ?? ""}).bind(to: viewModel.password).disposed(by: bag)
        
        viewModel.isValidInput.bind(to: btnLogin.rx.isEnabled).disposed(by: bag)
        viewModel.isValidInput.subscribe( onNext: { [weak self] isValid in
            self?.btnLogin.backgroundColor = isValid ? .systemBlue.withAlphaComponent(1.0) : .systemBlue.withAlphaComponent(0.3)
        }).disposed(by: bag)
    }
    
    @objc func btnLoginTapped() {
        
        guard let email = txtEmailId.text,
              let pass = txtPassword.text else { return }
        
        viewModel.authenticateCompany(request: LoginRequest(email: email, password: pass)) { result in
            if result?.errorMessage == nil, let companyName = result?.data?.name {
                self.mainCoordinator?.navigateToHomeVC(companyName: companyName)
            } else {
                self.alert(message: "Sorry! Please check your Credentials")
            }
        }
    }
    
    @objc func btnCreateAccountTapped() {
        mainCoordinator?.navigateToSignUpVC()
    }
    
}
