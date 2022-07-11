//
//  SignupViewModel.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import Foundation
import RxSwift
import RxCocoa

class SignupViewModel {
    
    var name:BehaviorSubject<String> = BehaviorSubject(value: "")
    var email:BehaviorSubject<String> = BehaviorSubject(value: "")
    var password:BehaviorSubject<String> = BehaviorSubject(value: "")
    var companyList: [Company] = []
    
    var isValidEmail:Observable<Bool> {
        email.map{$0.isValidEmail()}
    }
    
    var isValidPassword:Observable<Bool> {
        password.map { password in
            return password.count < 4 ? false : true
        }
    }
    
    var isValidName:Observable<Bool> {
        name.map { name in
            return name.count < 3 ? false : true
        }
    }
    
    var isValidInput:Observable<Bool> {
        return Observable.combineLatest(isValidEmail, isValidPassword, isValidName).map({ $0 && $1 && $2 })
    }
    
    func registerCompany(compnay: Company, completionHandler: @escaping(_ isRegistred: Bool?)->()) {
        let data = JSONDataManager.load(Filename.companyCred, with: [Company].self)
        companyList = data ?? []
        companyList.append(compnay)
        JSONDataManager.save(companyList, with: Filename.companyCred)
        completionHandler(true)
    }
    
}
