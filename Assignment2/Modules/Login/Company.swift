//
//  Company.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import Foundation

struct Company: Codable {
    var name: String
    var email: String
    var password: String
}

struct LoginRequest: Encodable {
    let email, password: String
}

struct LoginResponse : Decodable {
    let errorMessage: String?
    let data: Company?
}
