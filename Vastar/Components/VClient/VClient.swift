//
//  VClient.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class VClient {
    
    private static var mInstance:VClient?
    private let userDefault = UserDefaults.standard
    private var tds_userID:String? = ""
    
    static func sharedInstance() -> VClient {
        if mInstance == nil {
            mInstance = VClient();
        }
        return mInstance!
    }
    private init(){}
    
    // MARK: - Assistant Methods
    
    private func MD5_String(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
    private func MD5_Data(data: Data) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = data
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
    // MARK: - Login
    
    func VCLoginByPhone(account:String,pw:String,result:@escaping(_ isSuccess:Bool,_ message:String) -> Void) {
        
        let md5Data = MD5_String(string:pw)
        let md5Data1 = MD5_Data(data: md5Data)
        let md5Hex =  md5Data1.map { String(format: "%02hhx", $0) }.joined()
        let hashPassword = "0x\(md5Hex)"
        print("====> \(hashPassword)")
        CloudGatewayManager.sharedInstance().CGMLoginByPhone(account: account, hashPw: hashPassword) { (_ isSuccess:Bool,_ message:String) in
            result(isSuccess,message)
        }
    }
    
    func VCGetUserInfoByPhone(phone:String,result:@escaping(_ isSuccess:Bool,_ message:String,_ dictResData:[String:Any]) -> Void) {

        CloudGatewayManager.sharedInstance().CGMGetUserInfoByPhone(phone: phone) { (_ isSuccess:Bool,_ message:String,_ dictResData:[String:Any]) in
            result(isSuccess,message,dictResData)
        }
    }
}
