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
    
    //MARK:- Member
    
    
    //註冊
    func VCRegisterUserByData(pw:String,regBodyDict:[String:Any],result:@escaping (_ isSuccess:Bool,_ message:String) -> Void) {
        
        let md5Data = MD5_String(string:pw)
        let md5Data1 = MD5_Data(data: md5Data)
        let md5Hex =  md5Data1.map { String(format: "%02hhx", $0) }.joined()
        let hashPassword = "0x\(md5Hex)"
        var dataDict:[String:Any] = regBodyDict
        dataDict.updateValue(hashPassword, forKey: "HashPassword")
        
        CloudGatewayManager.sharedInstance().CGMRegisterUserByData(regBodyDict: dataDict) { (_ isSuccess:Bool,_ message:String) in
            result(isSuccess,message)
        }
    }
    
    //取得 User Info
    func VCGetUserInfoByPhone(phone:String,result:@escaping(_ isSuccess:Bool,_ message:String,_ dictResData:[String:Any]) -> Void) {

        CloudGatewayManager.sharedInstance().CGMGetUserInfoByPhone(phone: phone) { (_ isSuccess:Bool,_ message:String,_ dictResData:[String:Any]) in
            result(isSuccess,message,dictResData)
        }
    }
    
    
    //忘記密碼
    func VCUpdateForgetPw(phone:String,newPw:String,result:@escaping(_ isSuccess:Bool,_ message:String) -> Void) {
        
        let md5Data = MD5_String(string:newPw)
        let md5Data1 = MD5_Data(data: md5Data)
        let md5Hex =  md5Data1.map { String(format: "%02hhx", $0) }.joined()
        let hashPassword = "0x\(md5Hex)"
        
        var bodyDict:[String:String] = [:]
        bodyDict.updateValue("vastar", forKey: "UserID")
        bodyDict.updateValue("vastar@2673", forKey: "Password")
        bodyDict.updateValue(phone, forKey: "Account_Name")
        bodyDict.updateValue("UpdateHashPasswordForget", forKey: "UpdateMode")
        bodyDict.updateValue("", forKey: "OldHashPassword")
        bodyDict.updateValue(hashPassword, forKey: "NewHashPassword")
        bodyDict.updateValue("", forKey: "Name")
        bodyDict.updateValue("", forKey: "Birthday")
        bodyDict.updateValue("", forKey: "Telephone")
        
        CloudGatewayManager.sharedInstance().CGMUpdateUserInfoByData(reqBodyDict: bodyDict) { (_ isSuccess:Bool,_ message:String) in
            result(isSuccess,message)
        }
    }
    
    //修改密碼
    func VCUpdateChangePw(phone:String,oldPw:String,newPw:String,result:@escaping(_ isSuccess:Bool,_ message:String) -> Void) {
        
        let md5Data_o = MD5_String(string:oldPw)
        let md5Data1_o = MD5_Data(data: md5Data_o)
        let md5Hex_o =  md5Data1_o.map { String(format: "%02hhx", $0) }.joined()
        let old_hashPassword = "0x\(md5Hex_o)"
        
        let md5Data = MD5_String(string:newPw)
        let md5Data1 = MD5_Data(data: md5Data)
        let md5Hex =  md5Data1.map { String(format: "%02hhx", $0) }.joined()
        let new_hashPassword = "0x\(md5Hex)"
        
        print("舊====> \(old_hashPassword)")
        print("新====> \(new_hashPassword)")
        var bodyDict:[String:String] = [:]
        bodyDict.updateValue("vastar", forKey: "UserID")
        bodyDict.updateValue("vastar@2673", forKey: "Password")
        bodyDict.updateValue(phone, forKey: "Account_Name")
        bodyDict.updateValue("UpdateHashPasswordNew", forKey: "UpdateMode")
        bodyDict.updateValue(old_hashPassword, forKey: "OldHashPassword")
        bodyDict.updateValue(new_hashPassword, forKey: "NewHashPassword")
        bodyDict.updateValue("", forKey: "Name")
        bodyDict.updateValue("", forKey: "Birthday")
        bodyDict.updateValue("", forKey: "Telephone")
        
        CloudGatewayManager.sharedInstance().CGMUpdateUserInfoByData(reqBodyDict: bodyDict) { (_ isSuccess:Bool,_ message:String) in
            result(isSuccess,message)
        }
    }
    
    //修改名字
    func VCUpdateChangeName(phone:String,name:String,result:@escaping(_ isSuccess:Bool,_ message:String) -> Void) {
        
        var bodyDict:[String:String] = [:]
        bodyDict.updateValue("vastar", forKey: "UserID")
        bodyDict.updateValue("vastar@2673", forKey: "Password")
        bodyDict.updateValue(phone, forKey: "Account_Name")
        bodyDict.updateValue("UpdateName", forKey: "UpdateMode")
        bodyDict.updateValue("", forKey: "OldHashPassword")
        bodyDict.updateValue("", forKey: "NewHashPassword")
        bodyDict.updateValue(name, forKey: "Name")
        bodyDict.updateValue("", forKey: "Birthday")
        bodyDict.updateValue("", forKey: "Telephone")
        
        CloudGatewayManager.sharedInstance().CGMUpdateUserInfoByData(reqBodyDict: bodyDict) { (_ isSuccess:Bool,_ message:String) in
            result(isSuccess,message)
        }
        
    }
    
    //修改生日
    func VCUpdateChangeBirthday(phone:String,birthday:String,result:@escaping(_ isSuccess:Bool,_ message:String) -> Void) {
        
        var bodyDict:[String:String] = [:]
        bodyDict.updateValue("vastar", forKey: "UserID")
        bodyDict.updateValue("vastar@2673", forKey: "Password")
        bodyDict.updateValue(phone, forKey: "Account_Name")
        bodyDict.updateValue("UpdateBirthday", forKey: "UpdateMode")
        bodyDict.updateValue("", forKey: "OldHashPassword")
        bodyDict.updateValue("", forKey: "NewHashPassword")
        bodyDict.updateValue("", forKey: "Name")
        bodyDict.updateValue(birthday, forKey: "Birthday")
        bodyDict.updateValue("", forKey: "Telephone")
        
        CloudGatewayManager.sharedInstance().CGMUpdateUserInfoByData(reqBodyDict: bodyDict) { (_ isSuccess:Bool,_ message:String) in
            result(isSuccess,message)
        }
        
    }
    
    //修改電話
    
    func VCUpdateChangeTel(phone:String,tel:String,result:@escaping(_ isSuccess:Bool,_ message:String) -> Void) {
        
        var bodyDict:[String:String] = [:]
        bodyDict.updateValue("vastar", forKey: "UserID")
        bodyDict.updateValue("vastar@2673", forKey: "Password")
        bodyDict.updateValue(phone, forKey: "Account_Name")
        bodyDict.updateValue("UpdateTelephone", forKey: "UpdateMode")
        bodyDict.updateValue("", forKey: "OldHashPassword")
        bodyDict.updateValue("", forKey: "NewHashPassword")
        bodyDict.updateValue("", forKey: "Name")
        bodyDict.updateValue("", forKey: "Birthday")
        bodyDict.updateValue(tel, forKey: "Telephone")
        
        CloudGatewayManager.sharedInstance().CGMUpdateUserInfoByData(reqBodyDict: bodyDict) { (_ isSuccess:Bool,_ message:String) in
            result(isSuccess,message)
        }
        
    }
    
    
    //MARK: - Location
    
    func VCGetCityData(result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetCityData { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) in
            result(isSuccess,message,resDataArray)
        }
    }
    
    func VCGetDistrictData(city:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetDistrictData(city: city) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) in
            result(isSuccess,message,resDataArray)
        }
    }
    
    //MARK: - Recriver
    
    func VCAddReceiverByData(bodyArray:Array<String>,result:@escaping (_ isSuccess:Bool,_ message:String) -> Void) {
        
        let accountName:String = bodyArray[0]
        let receiver_Name:String = bodyArray[1]
        let receiver_Phone:String = bodyArray[2]
        let receiver_City:String = bodyArray[3]
        let receiver_District:String = bodyArray[4]
        let receiver_Address:String = bodyArray[5]
        
        var bodyDict:[String:String] = [:]
        bodyDict.updateValue("vastar", forKey: "UserID")
        bodyDict.updateValue("vastar@2673", forKey: "Password")
        bodyDict.updateValue(accountName, forKey: "Account_Name")
        bodyDict.updateValue(receiver_Name, forKey: "Receiver_Name")
        bodyDict.updateValue(receiver_Phone, forKey: "Receiver_Phone")
        bodyDict.updateValue(receiver_City, forKey: "Receiver_City")
        bodyDict.updateValue(receiver_District, forKey: "Receiver_District")
        bodyDict.updateValue(receiver_Address, forKey: "Receiver_Address")
        
        CloudGatewayManager.sharedInstance().CGMAddReceiverByData(reqBodyDict: bodyDict) { (_ isSuccess:Bool,_ message:String) in
            result(isSuccess,message)
        }
    }
    
    func VCGetReceiverData(phone:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetReceiverData(phone: phone) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            result(isSuccess,message,resDataArray)
        }
    }
    
    func VCDeleteReceiverByData(phone:String,delID:Int,result:@escaping (_ isSuccess:Bool,_ message:String) -> Void) {
        
        var bodyDict:[String:Any] = [:]
        bodyDict.updateValue("vastar", forKey: "UserID")
        bodyDict.updateValue("vastar@2673", forKey: "Password")
        bodyDict.updateValue(phone, forKey: "Account_Name")
        bodyDict.updateValue(delID, forKey: "ID")
        
        CloudGatewayManager.sharedInstance().CGMDeleteReceiverByData(reqBodyDict: bodyDict) { (_ isSuccess:Bool,_ message:String) in
            result(isSuccess,message)
        }
        
    }
    
    
    //MARK: - Product
    
    
    func VCGetAllProductData(result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetAllProductData { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            result(isSuccess,message,resDataArray)
        }
    }
    
    func CGMGetProductDataByType(type:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetProductDataByType(type: type) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            result(isSuccess,message,resDataArray)
        }
    }

}
