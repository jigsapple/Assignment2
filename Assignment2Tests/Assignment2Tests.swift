//
//  Assignment2Tests.swift
//  Assignment2Tests
//
//  Created by Jignesh on 15/06/22.
//

import XCTest
@testable import Assignment2

class Assignment2Tests: XCTestCase {

    func test_LoginAuthentication_With_Unknown_Record_Return_Failure() {
        
        //ARRANGE
        let viewModel = LoginViewModel()
        let loginRequest = LoginRequest(email: "abc@aa.cc", password: "11111")
        
        //ACT
        viewModel.authenticateCompany(request: loginRequest) { loginResponse in
            
            //ASSERTS
            XCTAssertEqual(loginResponse?.errorMessage, "Kindly Register to Login")
            XCTAssertNil(loginResponse?.data)
        }
    }
    
    func test_LoginAuthentication_With_Wrong_Password_Return_Failure() {
        
        //ARRANGE
        let viewModel = LoginViewModel()
        let loginRequest = LoginRequest(email: "Jems@jems.com", password: "jjjjj")
        
        //ACT
        viewModel.authenticateCompany(request: loginRequest) { loginResponse in
            
            //ASSERTS
            XCTAssertEqual(loginResponse?.errorMessage, "Please enter valid Credetial")
            XCTAssertNil(loginResponse?.data)
        }
    }
    
    func test_LoginAuthentication_With_ValidRequest_Return_Success() {
        
        //ARRANGE
        let viewModel = LoginViewModel()
        let loginRequest = LoginRequest(email: "Jems@jems.com", password: "12345")
        
        //ACT
        viewModel.authenticateCompany(request: loginRequest) { loginResponse in
            
            //ASSERTS
            XCTAssertNil(loginResponse?.errorMessage)
            XCTAssertEqual(loginResponse?.data?.name, "JigyatiInfotech")
        }
    }

}
