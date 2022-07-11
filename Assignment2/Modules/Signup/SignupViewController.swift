//
//  SignupViewController.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import UIKit
import RxSwift
import RxCocoa

class SignupViewController: UIViewController {
    
    //Create SignUp title
    lazy var lblSignUpTitle : UILabel = {
        let label = UILabel()
        label.text = "SIGNUP"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 42)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Create textfield
    lazy var txtName:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Company Name"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
    
    //Create SignUp button
    lazy var btnSignup : UIButton = {
        let btn = UIButton()
        btn.setTitle("SignUp", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        return btn
    }()
    
    var bag = DisposeBag()
    private let viewModel = SignupViewModel()
    weak var mainCoordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        createObservables()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(lblSignUpTitle)
        self.view.addSubview(txtEmailId)
        self.view.addSubview(txtPassword)
        self.view.addSubview(txtName)
        self.view.addSubview(btnSignup)
        
        NSLayoutConstraint.activate([
            lblSignUpTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 50),
            lblSignUpTitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -50),
            lblSignUpTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 150),
            txtName.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            txtName.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            txtName.topAnchor.constraint(equalTo: lblSignUpTitle.bottomAnchor,constant: 50),
            txtEmailId.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            txtEmailId.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            txtEmailId.topAnchor.constraint(equalTo: txtName.bottomAnchor,constant: 20),
            txtPassword.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            txtPassword.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            txtPassword.topAnchor.constraint(equalTo: txtEmailId.bottomAnchor,constant: 20),
            btnSignup.topAnchor.constraint(equalTo: txtPassword.bottomAnchor,constant: 40),
            btnSignup.widthAnchor.constraint(equalTo: txtEmailId.widthAnchor),
            btnSignup.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            btnSignup.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createObservables() {
        
        txtName.rx.text.map({$0 ?? ""}).bind(to: viewModel.name).disposed(by: bag)
        txtEmailId.rx.text.map({$0 ?? ""}).bind(to: viewModel.email).disposed(by: bag)
        txtPassword.rx.text.map({$0 ?? ""}).bind(to: viewModel.password).disposed(by: bag)
        
        viewModel.isValidInput.bind(to: btnSignup.rx.isEnabled).disposed(by: bag)
        viewModel.isValidInput.subscribe( onNext: { [weak self] isValid in
            self?.btnSignup.backgroundColor = isValid ? .systemBlue.withAlphaComponent(1.0) : .systemBlue.withAlphaComponent(0.3)
        }).disposed(by: bag)
    }
    
    @objc func btnSignUpTapped() {
        guard let name = txtName.text,
              let email = txtEmailId.text,
              let password = txtPassword.text else { return }
        do {
            let encryptedPassword = try CryptoManager.encryptMessage(message: password)
            let companyInfo = Company(name: name, email: email, password: encryptedPassword)
            self.viewModel.registerCompany(compnay: companyInfo) { result in
                if result ?? false {
                    let alert = UIAlertController(title: "Success", message: "Success..! Company Registration", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        self.mainCoordinator?.dismissVC()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
