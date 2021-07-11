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
    
    
    func VCSendMMSVerify(sendPhone:String,code:String,result:@escaping (_ isSuccess:Bool) -> Void) {
        
        let msg:String = "[飛騰家電] 您的認證碼是「\(code)」，請儘速進行驗證，切勿將驗證碼洩漏他人。"
        var bodyDict:[String:String] = [:]
        bodyDict.updateValue("0930908999", forKey: "UID")
        bodyDict.updateValue("mimichi999", forKey: "PWD")
        bodyDict.updateValue("簡訊驗證", forKey: "SB")
        bodyDict.updateValue(msg, forKey: "MSG")
        bodyDict.updateValue(sendPhone, forKey: "DEST")
        bodyDict.updateValue("", forKey: "ST")
        bodyDict.updateValue("1", forKey: "RETRYTIME")
        
        
        CloudGatewayManager.sharedInstance().CGMSendMMSVerify(reqBodyDict: bodyDict) { (_ isSuccess:Bool) in
            result(isSuccess)
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
    
    func VCGetPostalCodeData(city:String,town:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resData:String,_ isOutlying:Int) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetPostalCodeData(city: city, town: town) { (_ isSuccess:Bool,_ message:String,_ resData:String,_ isOutlying:Int) in
            result(isSuccess,message,resData,isOutlying)
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
    
    func VCGetProductDataByType(type:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetProductDataByType(type: type) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            result(isSuccess,message,resDataArray)
        }
    }
    
    func VCGGetProductGroupData(gID:Int,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetProductGroupData(gID: gID) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            result(isSuccess,message,resDataArray)
        }
    }
    
    func VCAddShoppingCarData(dataArray:Array<Any>,result:@escaping (_ isDone:Bool) -> Void){
        
        let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        var doneFlag:Bool = false
        let p_No:String = dataArray[0] as? String ?? ""
        let p_title:String = dataArray[1] as? String ?? ""
        let p_color:String = dataArray[2] as? String ?? ""
        let p_v:String = dataArray[3] as? String ?? ""
        let p_amount:Int = dataArray[4] as? Int ?? 0
        let p_price:Int = dataArray[5] as? Int ?? 0
        let imageData:NSData = dataArray[6] as! NSData

        let dbSqliteHelper = DBSqlite()
        let db = dbSqliteHelper.openDataBase("VastarDataBase")
        let sql:String = "Insert into 'shoppingCar' ('No','title','color','voltage','amount','price','photo','addtime')  VALUES (?,?,?,?,?,?,?,datetime('now', 'localtime'));"
        var stmt:OpaquePointer? = nil
        let sqlResult:Int = Int(sqlite3_prepare(db, sql, -1, &stmt, nil))
        if sqlResult == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, p_No, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 2, p_title, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 3, p_color, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 4, p_v, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(stmt, 5, Int32(p_amount))
            sqlite3_bind_int(stmt, 6, Int32(p_price))
            sqlite3_bind_blob(stmt, 7, imageData.bytes, Int32(imageData.length), SQLITE_TRANSIENT)

            if sqlite3_step(stmt) == SQLITE_DONE {
                doneFlag = true
                sqlite3_finalize(stmt)
            }else{
                print("---FFF---")
            }
        }
        
        dbSqliteHelper.closeDataBase()
        result(doneFlag)
    }
    
    func VCGetShoppingCarData(result:@escaping (_ dataArray:Array<Array<Any>>,_ isDone:Bool) -> Void){

        var DataArray:Array<Array<Any>> = []
        var doneFlag:Bool = false
        
        var IDArray:Array<Int> = []
        var NoArray:Array<String> = []
        var titleArray:Array<String> = []
        var colorArray:Array<String> = []
        var amountArray:Array<Int> = []
        var vArray:Array<String> = []
        var priceArray:Array<Int> = []
        var photoArray:Array<UIImage> = []
        
        let dbSqliteHelper = DBSqlite()
        let db = dbSqliteHelper.openDataBase("VastarDataBase")
        let sql:String = "select ID,No,title,color,sum(amount)as amountS, voltage, price,photo from shoppingCar group by title,color,voltage"
        var stmt:OpaquePointer? = nil
        let sqlResult:Int = Int(sqlite3_prepare(db, sql, -1, &stmt, nil))
        if sqlResult == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                
                let ID = sqlite3_column_int(stmt, 0)
                let No = UnsafePointer(sqlite3_column_text(stmt, 1))
                let title = UnsafePointer(sqlite3_column_text(stmt, 2))
                let color = UnsafePointer(sqlite3_column_text(stmt, 3))
                let amount = sqlite3_column_int(stmt, 4)
                let voltage = UnsafePointer(sqlite3_column_text(stmt, 5))
                let price = sqlite3_column_int(stmt, 6)
                let imageLength = sqlite3_column_bytes(stmt, 7)
                let imageData = NSData(bytes:sqlite3_column_blob(stmt, 7) , length: Int(imageLength))
                
                IDArray.append(Int(ID))
                NoArray.append(String.init(cString: No!))
                titleArray.append(String.init(cString: title!))
                colorArray.append(String.init(cString: color!))
                amountArray.append(Int(amount))
                vArray.append(String.init(cString: voltage!))
                priceArray.append(Int(price))
                photoArray.append(UIImage(data: imageData as Data)!)

                
            }
            doneFlag = true
            sqlite3_finalize(stmt)
            
            if IDArray.count != 0 || NoArray.count != 0 || titleArray.count != 0 || colorArray.count != 0 || amountArray.count != 0 || vArray.count != 0 || priceArray.count != 0 || photoArray.count != 0 {
                DataArray = [IDArray,NoArray,titleArray,colorArray,amountArray,vArray,priceArray,photoArray]
            }
        }else{
            doneFlag = false
        }
        
        dbSqliteHelper.closeDataBase()
        result(DataArray,doneFlag)
    }
    
    
    func VCDeleteShoppingCarDataByID(titleSt:String,colorSt:String,v:String,result:@escaping (_ isDone:Bool) -> Void) {
        
        var doneFlag:Bool = false
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let dbSqliteHelper = DBSqlite()
        let db = dbSqliteHelper.openDataBase("VastarDataBase")
        let sql:String = "DELETE FROM shoppingCar WHERE title = ? and color = ? and voltage = ?"
        var stmt:OpaquePointer? = nil
        let sqlResult:Int = Int(sqlite3_prepare(db, sql, -1, &stmt, nil))
        if sqlResult == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, titleSt, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 2, colorSt, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 3, v, -1, SQLITE_TRANSIENT)

            if sqlite3_step(stmt) == SQLITE_DONE {

                doneFlag = true
                sqlite3_finalize(stmt)
            }else{
                print("---FFF---")
            }
        }
        
        dbSqliteHelper.closeDataBase()
        result(doneFlag)
    }
    
    func VCDeleteAllShoppingCarData(result:@escaping (_ isDone:Bool) -> Void) {
        
        var doneFlag:Bool = false

        let dbSqliteHelper = DBSqlite()
        let db = dbSqliteHelper.openDataBase("VastarDataBase")
        let sql:String = "DELETE FROM shoppingCar;UPDATE SQLITE_SEQUENCE SET seq = 0 WHERE name = 'shoppingCar';VACUUM;"
        var stmt:OpaquePointer? = nil
        let sqlResult:Int = Int(sqlite3_prepare(db, sql, -1, &stmt, nil))
        if sqlResult == SQLITE_OK {
            
            if sqlite3_step(stmt) == SQLITE_DONE {

                doneFlag = true
                sqlite3_finalize(stmt)
            }else{
                print("---FFF---")
            }
        }
        
        dbSqliteHelper.closeDataBase()
        result(doneFlag)
    }
    
    //MARK: - Shipping
    
    func VCGetShippingData(productNo:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ mainPrice:Int,_ OutlyingPrice:Int) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetShippingData(productNo: productNo) { (_ isSuccess:Bool,_ message:String,_ mainPrice:Int,_ OutlyingPrice:Int) in
            result(isSuccess,message,mainPrice,OutlyingPrice)
        }
    }
    
    //MARK:- Order
    
    func VCGetOrderListData(phone:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        CloudGatewayManager.sharedInstance().CGMGetOrderListData(phone: phone) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            result(isSuccess,message,resDataArray)
        }
    }
    
    
    func VCAddOrderByData(reqBodyDict:[String:Any],result:@escaping (_ isSuccess:Bool,_ message:String,_ orderNo:String) -> Void) {
        CloudGatewayManager.sharedInstance().CGMAddOrderByData(reqBodyDict: reqBodyDict) { (_ isSuccess:Bool,_ message:String,_ orderNo:String) in
            result(isSuccess,message,orderNo)
        }
        
    }

}
