//
//  CloudGatewayManager.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import Foundation
import UIKit
import Alamofire

class CloudGatewayManager {
    
    private static var mInstance:CloudGatewayManager?
    static func sharedInstance() -> CloudGatewayManager {
        if mInstance == nil {
            mInstance = CloudGatewayManager();
        }
        return mInstance!
    }
    private init(){}
    
    
    //MARK: - Login
    
    func CGMLoginByPhone(account:String,hashPw:String,result:@escaping(_ isSuccess:Bool,_ message:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Account_Name" : account, "HashPassword" : hashPw]
        
        let urlString:String = vApiUrl + "/api/Member/Login"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                let jsonInfo = json as? [String : Any] ?? [:]
                
                var isResStatus:Bool = false
                let resStatus:Int = jsonInfo["Result"] as? Int ?? -1
                let messageStr:String = jsonInfo["Message"] as? String ?? ""
                if resStatus == 0 {
                    isResStatus = true
                }else{
                    isResStatus = false
                }
                
                result(isResStatus,messageStr)
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error")
                break
            }
        }
        
    }
    

    //MARK: - Member
    
    func CGMGetUserInfoByPhone(phone:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ dictResData:[String:Any]) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Account_Name" : phone]
        let urlString:String = vApiUrl + "/api/Member/Query"
        let url = URL.init(string: urlString)
        var dictData:[String:Any] = [:]
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                let jsonInfo = json as? [String : Any] ?? [:]
                var messageStr:String = ""
                var isResStatus:Bool = false
                let resStatus:Int = jsonInfo["Result"] as? Int ?? -1
                if resStatus == 0 {
                    messageStr = jsonInfo["Message"] as? String ?? ""
                    isResStatus = true
                    
                    let accountName:String = jsonInfo["Account_Name"] as? String ?? ""
                    let ID:Int = jsonInfo["ID"] as? Int ?? 0
                    let name:String = jsonInfo["Name"] as? String ?? ""
                    let birthday:String = jsonInfo["Birthday"] as? String ?? ""
                    let tel:String = jsonInfo["Telephone"] as? String ?? ""
                    let registerTime:String = jsonInfo["RegisterTime"] as? String ?? ""
                    
                    dictData.updateValue(accountName, forKey: "Account_Name")
                    dictData.updateValue(ID, forKey: "ID")
                    dictData.updateValue(name, forKey: "Name")
                    dictData.updateValue(birthday, forKey: "Birthday")
                    dictData.updateValue(tel, forKey: "Telephone")
                    dictData.updateValue(registerTime, forKey: "RegisterTime")
        
                }else{
                    messageStr = jsonInfo["Message"] as? String ?? ""
                    isResStatus = false
                }
                
                result(isResStatus,messageStr,dictData)
        
                break
            case .failure(_):
                
                result(false,"Error",[:])
                break
            }
        }
        
    }
    
    func CGMUpdateUserInfoByData(reqBodyDict:[String:String],result:@escaping (_ isSuccess:Bool,_ message:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = reqBodyDict
        let urlString:String = vApiUrl + "/api/Member/Update"
        let url = URL.init(string: urlString)
        
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                let jsonInfo = json as? [String : Any] ?? [:]
                
                var isResStatus:Bool = false
                let resStatus:Int = jsonInfo["Result"] as? Int ?? -1
                let messageStr:String = jsonInfo["Message"] as? String ?? ""
                if resStatus == 0 {
                    isResStatus = true
                }else{
                    isResStatus = false
                }
                
                result(isResStatus,messageStr)
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error")
                break
            }
        }
    }
    
    func CGMRegisterUserByData(regBodyDict:[String:Any],result:@escaping (_ isSuccess:Bool,_ message:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = regBodyDict
        let urlString:String = vApiUrl + "/api/Member/Register"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                let jsonInfo = json as? [String : Any] ?? [:]
                
                var isResStatus:Bool = false
                let resStatus:Int = jsonInfo["Result"] as? Int ?? -1
                let messageStr:String = jsonInfo["Message"] as? String ?? ""
                if resStatus == 0 {
                    isResStatus = true
                }else{
                    isResStatus = false
                }
                
                result(isResStatus,messageStr)
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error")
                break
            }
        }
        
    }
}
