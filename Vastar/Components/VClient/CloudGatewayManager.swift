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
    
    //MARK: -  Location
    
    //City
    
    func CGMGetCityData(result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673"]
        let urlString:String = vApiUrl + "/api/Location/QueryCity"
        let url = URL.init(string: urlString)
        var resCityDataArray:Array<String> = []
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count {
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let city:String = resultDict["City"] as? String ?? ""
                        if city != "選擇縣市" {
                            resCityDataArray.append(city)
                        }
                    }
                    result(true,"",resCityDataArray)
                    
                }else{
                    result(false,"statusCode = \(String(describing: responseData.response?.statusCode))",[])
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error",[])
                break
            }
        }
        
    }
    
    
    //District
    
    func CGMGetDistrictData(city:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673","City" : city]
        let urlString:String = vApiUrl + "/api/Location/QueryDistrict"
        let url = URL.init(string: urlString)
        var resDistrictDataArray:Array<String> = []
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count {
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let district:String = resultDict["District"] as? String ?? ""
                        let trimmed = district.replacingOccurrences(of: " ", with: "")
                        if district != "選擇行政區" {
                            resDistrictDataArray.append(trimmed)
                        }
                    }
                    result(true,"",resDistrictDataArray)
                    
                }else{
                    result(false,"statusCode = \(String(describing: responseData.response?.statusCode))",[])
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error",[])
                break
            }
        }
    }
    
    //MARK: - Receiver
    
    func CGMAddReceiverByData(reqBodyDict:[String:Any],result:@escaping (_ isSuccess:Bool,_ message:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = reqBodyDict
        let urlString:String = vApiUrl + "/api/Receiver/Insert"
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
    
    
    func CGMGetReceiverData(phone:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resReceiverDataArray:Array<Array<Any>> = []
        var receiverIDArray:Array<Int> = []
        var receiverNameArray:Array<String> = []
        var receiverPhoneArray:Array<String> = []
        var receiverCityArray:Array<String> = []
        var receiverDistrictArray:Array<String> = []
        var receiverAddressArray:Array<String> = []
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673","Account_Name" : phone]
        let urlString:String = vApiUrl + "/api/Receiver/Query"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count {
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let Id:Int = resultDict["ID"] as? Int ?? 0
                            let name:String = resultDict["Receiver_Name"] as? String ?? ""
                            let phone:String = resultDict["Receiver_Phone"] as? String ?? ""
                            let city:String = resultDict["Receiver_City"] as? String ?? ""
                            let district:String = resultDict["Receiver_District"] as? String ?? ""
                            let address:String = resultDict["Receiver_Address"] as? String ?? ""
                            
                            receiverIDArray.append(Id)
                            receiverNameArray.append(name)
                            receiverPhoneArray.append(phone)
                            receiverCityArray.append(city)
                            receiverDistrictArray.append(district)
                            receiverAddressArray.append(address)
                        }
                        
                    }
                    
                    if receiverIDArray.count != 0 || receiverNameArray.count != 0 || receiverPhoneArray.count != 0 || receiverCityArray.count != 0 || receiverDistrictArray.count != 0 || receiverAddressArray.count != 0 {
                        resReceiverDataArray = [receiverIDArray,receiverNameArray,receiverPhoneArray,receiverCityArray,receiverDistrictArray,receiverAddressArray]
                    }
                    result(true,"",resReceiverDataArray)
                    
                }else{
                    result(false,"statusCode = \(String(describing: responseData.response?.statusCode))",[])
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error",[])
                break
            }
        }
    }
    
    
    //Delete
    
    func CGMDeleteReceiverByData(reqBodyDict:[String:Any],result:@escaping (_ isSuccess:Bool,_ message:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = reqBodyDict
        let urlString:String = vApiUrl + "/api/Receiver/Delete"
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
