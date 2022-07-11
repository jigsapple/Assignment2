//
//  CryptoManager.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import Foundation
import RNCryptor

public class CryptoManager {
    
    static func encryptMessage(message: String) throws -> String {
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: Constant.securityKey)
        return cipherData.base64EncodedString()
    }
    
    static func decryptMessage(encryptedMessage: String) throws -> String {
        
        let encryptedData = Data.init(base64Encoded: encryptedMessage)!
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: Constant.securityKey)
        let decryptedString = String(data: decryptedData, encoding: .utf8)!
        
        return decryptedString
    }
}
