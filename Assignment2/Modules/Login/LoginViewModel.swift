//
//  LoginViewModel.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    var email:BehaviorSubject<String> = BehaviorSubject(value: "")
    var password:BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var isValidEmail:Observable<Bool> {
        email.map{$0.isValidEmail()}
    }
    
    var isValidPassword:Observable<Bool> {
        password.map { password in
            return password.count < 4 ? false : true
        }
    }
    
    var isValidInput:Observable<Bool> {
        return Observable.combineLatest(isValidEmail, isValidPassword).map({ $0 && $1 })
    }
    
    func authenticateCompany(request: LoginRequest, completionHandler: @escaping(_ loginResponse: LoginResponse?)->()) {
        
        guard let data = JSONDataManager.load(Filename.companyCred, with: [Company].self) else { return }
        //debugPrint(data)
        let companyData = data.filter{ $0.email == request.email }
        if let pass = companyData.first?.password {
            do {
                let decryptPass = try CryptoManager.decryptMessage(encryptedMessage: pass)
                
                if decryptPass == request.password {
                    completionHandler(LoginResponse(errorMessage: nil, data: companyData.first))
                    return
                } else {
                    completionHandler(LoginResponse(errorMessage: "Please enter valid Credetial", data: nil))
                    return
                }
            } catch {
                completionHandler(LoginResponse(errorMessage: error.localizedDescription, data: nil))
            }
        }
        completionHandler(LoginResponse(errorMessage: "Kindly Register to Login", data: nil))
    }
}
