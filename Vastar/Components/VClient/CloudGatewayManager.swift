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
    
    func CGMLoginByPhone(account:String,hashPw:String,result:@escaping(_ isSuccess:Bool,_ messageSt:String) -> Void) {
        
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
    
    //MARK: - 簡訊驗證
    
    func CGMSendMMSVerify(reqBodyDict:[String:String],result:@escaping (_ isSuccess:Bool) -> Void) {
        
        let parames:Parameters = reqBodyDict
        let urlString:String = "https://oms.every8d.com/API21/HTTP/sendSMS.ashx"
        let url = URL.init(string: urlString)
        
        Alamofire.request(url!, method: .get, parameters: parames, encoding: URLEncoding.default, headers: nil).validate().responseData { (responseData:DataResponse) in
            switch (responseData.result) {
            case .success(_):

                let code = responseData.response?.statusCode
                if code == 200 {
                    result(true)
                }
            
                break
            case .failure(_):
                
                break
            }
        }
        
    }
    

    //MARK: - Member
    
    //取得帳號資料
    
    func CGMGetUserInfoByPhone(phone:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ isResult:Int,_ dictResData:[String:Any]) -> Void) {
        
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
                    let mobilePhone:String = jsonInfo["MobilePhone"] as? String ?? ""
                    let address:String = jsonInfo["Address"] as? String ?? ""
                    
                    dictData.updateValue(accountName, forKey: "Account_Name")
                    dictData.updateValue(ID, forKey: "ID")
                    dictData.updateValue(name, forKey: "Name")
                    dictData.updateValue(birthday, forKey: "Birthday")
                    dictData.updateValue(tel, forKey: "Telephone")
                    dictData.updateValue(registerTime, forKey: "RegisterTime")
                    dictData.updateValue(mobilePhone, forKey: "MobilePhone")
                    dictData.updateValue(address, forKey: "Address")
        
                }else{
                    messageStr = jsonInfo["Message"] as? String ?? ""
                    isResStatus = true
                }
                
                result(isResStatus,messageStr,resStatus,dictData)
        
                break
            case .failure(let error):
                result(false,"Error",-1,[:])
                break
            }
        }
        
    }
    
    //更新帳號資料
    
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
    
    //註冊帳號
    
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
    
    //帳號刪除
    
    func CGMDeleteUserByPhone(phone:String,delTime:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ isResult:Int) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Account_Name" : phone, "DeleteTime" : delTime]
        let urlString:String = vApiUrl + "/api/Member/Delete"
        let url = URL.init(string: urlString)
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
                }else{
                    messageStr = jsonInfo["Message"] as? String ?? ""
                    isResStatus = true
                }
                
                result(isResStatus,messageStr,resStatus)
        
                break
            case .failure(_):
                
                result(false,"Error",-1)
                break
            }
        }
        
    }
    
    
    //MARK: -  Location
    
    //取得City資料
    
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
    
    
    //取得 District 資料
    
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
                            resDistrictDataArray.append(district)
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
    
    //取得郵遞區號
    
    func CGMGetPostalCodeData(city:String,town:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resData:String,_ isOutlying:Int) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "City" : city, "District" : town]
        let urlString:String = vApiUrl + "/api/Location/Query"
        let url = URL.init(string: urlString)
        var postalCode:String = ""
        var outlying:Int = 0
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                    
                    let jsonInfo = json as? [String : Any] ?? [:]
                    var messageStr:String = ""
                    let resStatus:Int = jsonInfo["Result"] as? Int ?? -1
                    if resStatus == 0 {
                        postalCode = jsonInfo["District_Code"] as? String ?? ""
                        outlying = jsonInfo["OutlyingIsland"] as? Int ?? 0
                    }else{
                        messageStr = jsonInfo["Message"] as? String ?? ""
                    }
                
                    result(true,messageStr,postalCode,outlying)
                    
                }else{
                    result(false,"statusCode = \(String(describing: responseData.response?.statusCode))","",outlying)
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error","",0)
                break
            }
        }
        
    }
    
    //MARK: - Receiver
    
    //新增收件人資料
    
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
    
    // 取得收件人資料
    
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
    
    
    //刪除收件人資料
    
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
    
    
    //MARK: - Product
    
    //取得所有商品資料
    
    func CGMGetAllProductData(result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resProductDataArray:Array<Array<Any>> = []
        var productOrderArray:Array<Int> = []
        var productGroupArray:Array<Int> = []
        var productNameArray:Array<String> = []
        var productImageUrlArray:Array<String> = []
        var messageStr:String = ""
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673"]
        let urlString:String = vApiUrl + "/api/Product/QueryAll"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let order:Int = resultDict["Product_Order"] as? Int ?? 0
                            let groupID:Int = resultDict["Product_Group"] as? Int ?? 0
                            let name:String = resultDict["Product_Name"] as? String ?? ""
                            let imageUrlSt:String = resultDict["Thumbnail_Address"] as? String ?? ""

                            productOrderArray.append(order)
                            productGroupArray.append(groupID)
                            productNameArray.append(name)
                            productImageUrlArray.append(imageUrlSt)

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    if productOrderArray.count != 0 || productGroupArray.count != 0 || productNameArray.count != 0 || productImageUrlArray.count != 0  {
                        resProductDataArray = [productOrderArray,productGroupArray,productNameArray,productImageUrlArray]
                    }
                    result(true,messageStr,resProductDataArray)
                    
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
    
    // 取得不同類型商品資料
    
    func CGMGetProductDataByType(type:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resProductDataArray:Array<Array<Any>> = []
        var productOrderArray:Array<Int> = []
        var productGroupArray:Array<Int> = []
        var productNameArray:Array<String> = []
        var productImageUrlArray:Array<String> = []
        var messageStr:String = ""
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "ProductType" : type]
        let urlString:String = vApiUrl + "/api/Product/QueryProductType"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let order:Int = resultDict["Product_Order"] as? Int ?? 0
                            let groupID:Int = resultDict["Product_Group"] as? Int ?? 0
                            let name:String = resultDict["Product_Name"] as? String ?? ""
                            let imageUrlSt:String = resultDict["Thumbnail_Address"] as? String ?? ""

                            productOrderArray.append(order)
                            productGroupArray.append(groupID)
                            productNameArray.append(name)
                            productImageUrlArray.append(imageUrlSt)

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    if productOrderArray.count != 0 || productGroupArray.count != 0 || productNameArray.count != 0 || productImageUrlArray.count != 0  {
                        resProductDataArray = [productOrderArray,productGroupArray,productNameArray,productImageUrlArray]
                    }
                    result(true,messageStr,resProductDataArray)
                    
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
    
    // 取得單項商品資料
    
    func CGMGetProductGroupData(gID:Int,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resProductDataArray:Array<Array<Any>> = []
        var productCodeArray:Array<String> = []
        var productNoArray:Array<String> = []
        var productNameArray:Array<String> = []
        var productPriceArray:Array<Int> = []
        var productVoltageArray:Array<String> = []
        var productColorArray:Array<String> = []
        var productImageUrlArray:Array<String> = []
        var productContentArray:Array<String> = []
        var messageStr:String = ""
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Product_Group" : gID]
        let urlString:String = vApiUrl + "/api/Product/QueryProduct_Group"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let code:String = resultDict["Product_Code"] as? String ?? ""
                            let NO:String = resultDict["Product_No"] as? String ?? ""
                            let name:String = resultDict["Product_Name"] as? String ?? ""
                            let price:Int = resultDict["Product_Price"] as? Int ?? 0
                            let voltage:String = resultDict["Product_Voltage"] as? String ?? ""
                            let color:String = resultDict["Product_Color"] as? String ?? ""
                            let imageUrlSt:String = resultDict["Thumbnail_Address"] as? String ?? ""
                            let content:String = resultDict["Remark"] as? String ?? ""

                            productCodeArray.append(code)
                            productNoArray.append(NO)
                            productNameArray.append(name)
                            productPriceArray.append(price)
                            productVoltageArray.append(voltage)
                            productColorArray.append(color)
                            productImageUrlArray.append(imageUrlSt)
                            productContentArray.append(content)

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    resProductDataArray = [productCodeArray,productNoArray,productNameArray,productPriceArray,productVoltageArray,productColorArray,productImageUrlArray,productContentArray]
                    
                    result(true,messageStr,resProductDataArray)
                    
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
    
    func CGMGetProductImagUrlByNo(productNo:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resUrl:String,_ isDone:Bool) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Product_No" : productNo]
        let urlString:String = vApiUrl + "/api/Product/QueryProduct_No"
        let url = URL.init(string: urlString)
        print("\(urlString)")
        var messageStr:String = ""
        var imgUrl:String = ""
        var flag:Bool = false
        
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
  
                    let jsonInfo = json as? [String : Any] ?? [:]
                    let res:Int = jsonInfo["Result"] as? Int ?? 0
                    if res == 0 {
                        
                        imgUrl = jsonInfo["Thumbnail_Address"] as? String ?? ""
                        messageStr = jsonInfo["Message"] as? String ?? ""
                        flag = true
                    }else{
                        
                        messageStr = jsonInfo["Message"] as? String ?? ""
                    }
                    
                    result(true,messageStr,imgUrl,flag)
                }else{
                    result(false,"","",flag)
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"","",false)
                
                break
            }
        }
        
    }
    
    
    func CGMGetProductInfoByNo(productNo:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resUrl:String,_ resName:String,_ resGroup:Int,_ isDone:Bool) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Product_No" : productNo]
        let urlString:String = vApiUrl + "/api/Product/QueryProduct_No"
        let url = URL.init(string: urlString)
        print("\(urlString)")
        var messageStr:String = ""
        var imgUrl:String = ""
        var name:String = ""
        var product_group:Int = 0
        var flag:Bool = false
        
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
  
                    let jsonInfo = json as? [String : Any] ?? [:]
                    let res:Int = jsonInfo["Result"] as? Int ?? 0
                    if res == 0 {
                        
                        imgUrl = jsonInfo["Thumbnail_Address"] as? String ?? ""
                        name = jsonInfo["Product_Name"] as? String ?? ""
                        product_group = jsonInfo["Product_Group"] as? Int ?? 0
                        messageStr = jsonInfo["Message"] as? String ?? ""
                        flag = true
                    }else{
                        
                        messageStr = jsonInfo["Message"] as? String ?? ""
                        flag = true
                    }
                    
                    result(true,messageStr,imgUrl,name,product_group,flag)
                }else{
                    result(false,"","","",0,flag)
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"","","",0,false)
                
                break
            }
        }
        
    }
    
    //MARK: - 付款方式
    
    // 取得付款方式
    
    func CGMGetPayMethodData(result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673"]
        let urlString:String = vApiUrl + "/api/Payment/Query"
        let url = URL.init(string: urlString)
        var resMethodDataArray:Array<String> = []
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count {
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let method:String = resultDict["Method"] as? String ?? ""
                        if method != "選擇付款方式" {
                            resMethodDataArray.append(method)
                        }
                    }
                    result(true,"",resMethodDataArray)
                    
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
    
    
    //MARK: - 運費
    
    // 取得運費
    
    func CGMGetShippingData(productNo:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ mainPrice:Int,_ OutlyingPrice:Int) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Product_No" : productNo]
        let urlString:String = vApiUrl + "/api/Shipping/Query"
        let url = URL.init(string: urlString)
        var main:Int = 0
        var outlying:Int = 0
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                    
                    let jsonInfo = json as? [String : Any] ?? [:]
                    var messageStr:String = ""
                    let resStatus:Int = jsonInfo["Result"] as? Int ?? -1
                    if resStatus == 0 {
                        main = jsonInfo["MainIsland"] as? Int ?? 0
                        outlying = jsonInfo["OutlyingIsland"] as? Int ?? 0
                    }else{
                        messageStr = jsonInfo["Message"] as? String ?? ""
                    }
                
                    result(true,messageStr,main,outlying)
                    
                }else{
                    result(false,"statusCode = \(String(describing: responseData.response?.statusCode))",main,outlying)
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error",0,0)
                break
            }
        }
        
    }
    
    //MARK:- Order
    
    // 取得訂單資料
    
    func CGMGetOrderListData(phone:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resProductDataArray:Array<Array<Any>> = []
        
        var orderIDArray:Array<Int> = []
        var orderNoArray:Array<String> = []
        var orderAccountNameArray:Array<String> = []
        var orderTotalProductPriceArray:Array<Int> = []
        var orderFeeArray:Array<Int> = []
        var orderTotalPriceArray:Array<Int> = []
        var orderReceiverNameArray:Array<String> = []
        var orderReceiverPhoneArray:Array<String> = []
        var orderReceiverCityArray:Array<String> = []
        var orderReceiverTownArray:Array<String> = []
        var orderReceiverCityCodeArray:Array<String> = []
        var orderReceiverAddressArray:Array<String> = []
        var orderShippingMethodArray:Array<String> = []
        var orderPaymentMethodArray:Array<String> = []
        var orderCreateTimeArray:Array<String> = []
        var orderStatusArray:Array<String> = []
        var deliveryTimeArray:Array<String> = []
        var packageDeliveryCodeArray:Array<String> = []
        var packageDeliveryUrlArray:Array<String> = []
        var orderCompleteTimeArray:Array<String> = []
        
        var messageStr:String = ""
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Account_Name" : phone]
        let urlString:String = vApiUrl + "/api/Order/QueryNew"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let ID:Int = resultDict["ID"] as? Int ?? 0
                            let NO:String = resultDict["Order_No"] as? String ?? ""
                            let accountName:String = resultDict["Account_Name"] as? String ?? ""
                            let totalProductPrice:Int = resultDict["TotalProductPrice"] as? Int ?? 0
                            let fee:Int = resultDict["ShippingFee"] as? Int ?? 0
                            let totalPrice:Int = resultDict["TotalPrice"] as? Int ?? 0
                            let r_Name:String = resultDict["Receiver_Name"] as? String ?? ""
                            let r_Phone:String = resultDict["Receiver_Phone"] as? String ?? ""
                            let r_City:String = resultDict["Receiver_City"] as? String ?? ""
                            let r_Town:String = resultDict["Receiver_District"] as? String ?? ""
                            let r_CityCode:String = resultDict["Receiver_CityCode"] as? String ?? ""
                            let r_Address:String = resultDict["Receiver_Address"] as? String ?? ""
                            let shippingMethod:String = resultDict["ShippingMethod"] as? String ?? ""
                            let payMethod:String = resultDict["PaymentMethod"] as? String ?? ""
                            let createTime:String = resultDict["OrderEstablishTime"] as? String ?? ""
                            let status:String = resultDict["Order_Status"] as? String ?? ""
                            let deliveryTime:String = resultDict["DeliveryTime"] as? String ?? ""
                            let packageDeliveryCode:String = resultDict["PackageDeliveryCode"] as? String ?? ""
                            let packageDeliveryUrl:String = resultDict["PackageDeliveryUrl"] as? String ?? ""
                            let orderCompleteTime:String = resultDict["OrderCompleteTime"] as? String ?? ""

                            orderIDArray.append(ID)
                            orderNoArray.append(NO)
                            orderAccountNameArray.append(accountName)
                            orderTotalProductPriceArray.append(totalProductPrice)
                            orderFeeArray.append(fee)
                            orderTotalPriceArray.append(totalPrice)
                            orderReceiverNameArray.append(r_Name)
                            orderReceiverPhoneArray.append(r_Phone)
                            orderReceiverCityArray.append(r_City)
                            orderReceiverTownArray.append(r_Town)
                            orderReceiverCityCodeArray.append(r_CityCode)
                            orderReceiverAddressArray.append(r_Address)
                            orderShippingMethodArray.append(shippingMethod)
                            orderPaymentMethodArray.append(payMethod)
                            orderCreateTimeArray.append(createTime)
                            orderStatusArray.append(status)
                            deliveryTimeArray.append(deliveryTime)
                            packageDeliveryCodeArray.append(packageDeliveryCode)
                            packageDeliveryUrlArray.append(packageDeliveryUrl)
                            orderCompleteTimeArray.append(orderCompleteTime)

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    resProductDataArray = [orderIDArray,orderNoArray,orderAccountNameArray,orderTotalProductPriceArray,orderFeeArray,orderTotalPriceArray,orderReceiverNameArray,orderReceiverPhoneArray,orderReceiverCityArray,orderReceiverTownArray,orderReceiverCityCodeArray,orderReceiverAddressArray,orderShippingMethodArray,orderPaymentMethodArray,orderCreateTimeArray,orderStatusArray,deliveryTimeArray,packageDeliveryCodeArray,packageDeliveryUrlArray,orderCompleteTimeArray]
                    
                    result(true,messageStr,resProductDataArray)
                    
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
    
    // 新增訂單
    
    func CGMAddOrderByData(reqBodyDict:[String:Any],result:@escaping (_ isSuccess:Bool,_ message:String,_ orderNo:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = reqBodyDict
        let urlString:String = vApiUrl + "/api/Order/Insert"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                let jsonInfo = json as? [String : Any] ?? [:]
                
                var isResStatus:Bool = false
                let resStatus:Int = jsonInfo["Result"] as? Int ?? -1
                let messageStr:String = jsonInfo["Message"] as? String ?? ""
                var orderNoSt:String = ""
                if resStatus == 0 {
                    isResStatus = true
                    orderNoSt = jsonInfo["Order_No"] as? String ?? ""
                }else{
                    isResStatus = false
                }
                
                result(isResStatus,messageStr,orderNoSt)
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error","")
                break
            }
        }
    }
    
    //新增訂單詳細內容
    
    func CGMAddOrderDetailByData(reqBodyDict:[String:Any],result:@escaping (_ isSuccess:Bool,_ message:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = reqBodyDict
        let urlString:String = vApiUrl + "/api/OrderDetail/Insert"
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
    
    // 取得歷史訂單資料
    
    func CGMGetHistoryOrderListData(phone:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resProductDataArray:Array<Array<Any>> = []
        
        var orderIDArray:Array<Int> = []
        var orderNoArray:Array<String> = []
        var orderAccountNameArray:Array<String> = []
        var orderTotalProductPriceArray:Array<Int> = []
        var orderFeeArray:Array<Int> = []
        var orderTotalPriceArray:Array<Int> = []
        var orderReceiverNameArray:Array<String> = []
        var orderReceiverPhoneArray:Array<String> = []
        var orderReceiverCityArray:Array<String> = []
        var orderReceiverTownArray:Array<String> = []
        var orderReceiverCityCodeArray:Array<String> = []
        var orderReceiverAddressArray:Array<String> = []
        var orderShippingMethodArray:Array<String> = []
        var orderPaymentMethodArray:Array<String> = []
        var orderCreateTimeArray:Array<String> = []
        var orderStatusArray:Array<String> = []
        var deliveryTimeArray:Array<String> = []
        var packageDeliveryCodeArray:Array<String> = []
        var packageDeliveryUrlArray:Array<String> = []
        var orderCompleteTimeArray:Array<String> = []
        
        
        var messageStr:String = ""
        print(">>>\(phone)")
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Account_Name" : phone]
        let urlString:String = vApiUrl + "/api/Order/QueryHistory"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                print("---> \(json)")
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let ID:Int = resultDict["ID"] as? Int ?? 0
                            let NO:String = resultDict["Order_No"] as? String ?? ""
                            let accountName:String = resultDict["Account_Name"] as? String ?? ""
                            let totalProductPrice:Int = resultDict["TotalProductPrice"] as? Int ?? 0
                            let fee:Int = resultDict["ShippingFee"] as? Int ?? 0
                            let totalPrice:Int = resultDict["TotalPrice"] as? Int ?? 0
                            let r_Name:String = resultDict["Receiver_Name"] as? String ?? ""
                            let r_Phone:String = resultDict["Receiver_Phone"] as? String ?? ""
                            let r_City:String = resultDict["Receiver_City"] as? String ?? ""
                            let r_Town:String = resultDict["Receiver_District"] as? String ?? ""
                            let r_CityCode:String = resultDict["Receiver_CityCode"] as? String ?? ""
                            let r_Address:String = resultDict["Receiver_Address"] as? String ?? ""
                            let shippingMethod:String = resultDict["ShippingMethod"] as? String ?? ""
                            let payMethod:String = resultDict["PaymentMethod"] as? String ?? ""
                            let createTime:String = resultDict["OrderEstablishTime"] as? String ?? ""
                            let status:String = resultDict["Order_Status"] as? String ?? ""
                            let deliveryTime:String = resultDict["DeliveryTime"] as? String ?? ""
                            let packageDeliveryCode:String = resultDict["PackageDeliveryCode"] as? String ?? ""
                            let packageDeliveryUrl:String = resultDict["PackageDeliveryUrl"] as? String ?? ""
                            let orderCompleteTime:String = resultDict["OrderCompleteTime"] as? String ?? ""

                            orderIDArray.append(ID)
                            orderNoArray.append(NO)
                            orderAccountNameArray.append(accountName)
                            orderTotalProductPriceArray.append(totalProductPrice)
                            orderFeeArray.append(fee)
                            orderTotalPriceArray.append(totalPrice)
                            orderReceiverNameArray.append(r_Name)
                            orderReceiverPhoneArray.append(r_Phone)
                            orderReceiverCityArray.append(r_City)
                            orderReceiverTownArray.append(r_Town)
                            orderReceiverCityCodeArray.append(r_CityCode)
                            orderReceiverAddressArray.append(r_Address)
                            orderShippingMethodArray.append(shippingMethod)
                            orderPaymentMethodArray.append(payMethod)
                            orderCreateTimeArray.append(createTime)
                            orderStatusArray.append(status)
                            deliveryTimeArray.append(deliveryTime)
                            packageDeliveryCodeArray.append(packageDeliveryCode)
                            packageDeliveryUrlArray.append(packageDeliveryUrl)
                            orderCompleteTimeArray.append(orderCompleteTime)

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    resProductDataArray = [orderIDArray,orderNoArray,orderAccountNameArray,orderTotalProductPriceArray,orderFeeArray,orderTotalPriceArray,orderReceiverNameArray,orderReceiverPhoneArray,orderReceiverCityArray,orderReceiverTownArray,orderReceiverCityCodeArray,orderReceiverAddressArray,orderShippingMethodArray,orderPaymentMethodArray,orderCreateTimeArray,orderStatusArray,deliveryTimeArray,packageDeliveryCodeArray,packageDeliveryUrlArray,orderCompleteTimeArray]
                    
                    result(true,messageStr,resProductDataArray)
                    
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
    
    func CGMGetOrderNumericalByOrderNo(order_No:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Any>) -> Void) {

        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Order_No" : order_No]
        let urlString:String = vApiUrl + "/api/Order/QueryOrder_No"
        let url = URL.init(string: urlString)
        print("\(urlString)")
        var messageStr:String = ""
        var dataArray:Array<Any> = []
        
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
  
                    let jsonInfo = json as? [String : Any] ?? [:]
                    let res:Int = jsonInfo["Result"] as? Int ?? 0
                    if res == 0 {
                        let price:Int = jsonInfo["TotalPrice"] as? Int ?? 0
                        let number:String = jsonInfo["NumericalOrder"] as? String ?? ""
                        let pay:String = jsonInfo["PaymentMethod"] as? String ?? ""
                        
                        dataArray = [price,number,pay]
                        messageStr = jsonInfo["Message"] as? String ?? ""
                        
                    }else{
                        
                        messageStr = jsonInfo["Message"] as? String ?? ""
                    }
                    
                    result(true,messageStr,dataArray)
                }else{
                    result(false,"",[])
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"",[])
                
                break
            }
        }
    }
    
    func CGMUpdateOrderStatus(reqBodyDict:[String:String],result:@escaping (_ isSuccess:Bool,_ message:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let params:Parameters = reqBodyDict
        let urlString:String = vApiUrl + "/api/Order/UpdateOrder_Status"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
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
    
    func CGMGetOrderDetailByNo(orderNo:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resProductDataArray:Array<Array<Any>> = []
        
        var IDArray:Array<Int> = []
        var accountNameArray:Array<String> = []
        var productNoArray:Array<String> = []
        var productNameArray:Array<String> = []
        var productVoltageArray:Array<String> = []
        var productColorArray:Array<String> = []
        var productPriceArray:Array<Int> = []
        var productQuantityArray:Array<Int> = []
        var productTotalPriceArray:Array<Int> = []
       
        var messageStr:String = ""

        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "order_No" : orderNo]
        let urlString:String = vApiUrl + "/api/OrderDetail/Query"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                print("---> \(json)")
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let ID:Int = resultDict["ID"] as? Int ?? 0
                            let accountName:String = resultDict["Account_Name"] as? String ?? ""
                            let NO:String = resultDict["Product_No"] as? String ?? ""
                            let name:String = resultDict["Product_Name"] as? String ?? ""
                            let voltage:String = resultDict["Product_Voltage"] as? String ?? ""
                            let color:String = resultDict["Product_Color"] as? String ?? ""
                            let price:Int = resultDict["Product_Price"] as? Int ?? 0
                            let quantity:Int = resultDict["Quantity"] as? Int ?? 0
                            let totalPrice:Int = resultDict["TotalPrice"] as? Int ?? 0
                            

                            IDArray.append(ID)
                            accountNameArray.append(accountName)
                            productNoArray.append(NO)
                            productNameArray.append(name)
                            productVoltageArray.append(voltage)
                            productColorArray.append(color)
                            productPriceArray.append(price)
                            productQuantityArray.append(quantity)
                            productTotalPriceArray.append(totalPrice)

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    resProductDataArray = [IDArray,accountNameArray,productNoArray,productNameArray,productVoltageArray,productColorArray,productPriceArray,productQuantityArray,productTotalPriceArray]
                    
                    result(true,messageStr,resProductDataArray)
                    
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
    
     //MARK: - 金流
    
    func CGMGetTransactionUrl(reqBodyDict:[String:String],result:@escaping (_ isSuccess:Bool,_ message:String,_ resString:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = reqBodyDict
        let urlString:String = "https://a.intella.co/allpaypass/api/general"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                    print("---> \(json)")
                    
                    let jsonInfo = json as? [String : Any] ?? [:]
                    let resSt:String = jsonInfo["Response"] as? String ?? ""
                    
                    result(true,"",resSt)
                }else{
                    result(false,"","")
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"","")
                
                break
            }
        }
    }
    
    
    //MARK: - 影片
    
    func CGMGetVideoListByProductType(type:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resVideoDataArray:Array<Array<Any>> = []
        
        var videoOrderArray:Array<Int> = []
        var vimeoIDArray:Array<String> = []
        var videoSeriesArray:Array<String> = []
        var videoNameArray:Array<String> = []
        var videoImageUrlArray:Array<String> = []
        var videoTypeArray:Array<String> = []
        
        var messageStr:String = ""

        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "ProductType" : type]
        let urlString:String = vApiUrl + "/api/Video/Query"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let order:Int = resultDict["Video_Order"] as? Int ?? 0
                            let vimeoID:String = resultDict["Vimeo_ID"] as? String ?? ""
                            let series:String = resultDict["Video_Series"] as? String ?? ""
                            let name:String = resultDict["Video_Name"] as? String ?? ""
                            let imagUrl:String = resultDict["Thumbnail_ID"] as? String ?? ""
                            let v_type:String = resultDict["Video_Type"] as? String ?? ""
                            
                            videoOrderArray.append(order)
                            vimeoIDArray.append(vimeoID)
                            videoSeriesArray.append(series)
                            videoNameArray.append(name)
                            videoImageUrlArray.append(imagUrl)
                            videoTypeArray.append(v_type)

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    resVideoDataArray = [videoOrderArray,vimeoIDArray,videoSeriesArray,videoNameArray,videoImageUrlArray,videoTypeArray]
                    
                    result(true,messageStr,resVideoDataArray)
                    
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
    
    
    func CGMGetVideoListByType(type:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resVideoDataArray:Array<Array<Any>> = []
        
        var videoOrderArray:Array<Int> = []
        var vimeoIDArray:Array<String> = []
        var videoSeriesArray:Array<String> = []
        var videoNameArray:Array<String> = []
        var videoImageUrlArray:Array<String> = []
        var videoTypeArray:Array<String> = []
        
        var messageStr:String = ""

        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Video_Type" : type]
        let urlString:String = vApiUrl + "/api/Video/Query"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let order:Int = resultDict["Video_Order"] as? Int ?? 0
                            let vimeoID:String = resultDict["Vimeo_ID"] as? String ?? ""
                            let series:String = resultDict["Video_Series"] as? String ?? ""
                            let name:String = resultDict["Video_Name"] as? String ?? ""
                            let imagUrl:String = resultDict["Thumbnail_ID"] as? String ?? ""
                            let v_type:String = resultDict["Video_Type"] as? String ?? ""
                            
                            videoOrderArray.append(order)
                            vimeoIDArray.append(vimeoID)
                            videoSeriesArray.append(series)
                            videoNameArray.append(name)
                            videoImageUrlArray.append(imagUrl)
                            videoTypeArray.append(v_type)
                            

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    resVideoDataArray = [videoOrderArray,vimeoIDArray,videoSeriesArray,videoNameArray,videoImageUrlArray,videoTypeArray]
                    
                    result(true,messageStr,resVideoDataArray)
                    
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
    
    
    func CGMGetVideoListBySeries(series:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) -> Void) {
        
        var resVideoDataArray:Array<Array<Any>> = []
        
        var videoOrderArray:Array<Int> = []
        var vimeoIDArray:Array<String> = []
        var videoSeriesArray:Array<String> = []
        var videoNameArray:Array<String> = []
        var videoImageUrlArray:Array<String> = []
        var videoTypeArray:Array<String> = []
        
        var messageStr:String = ""

        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Video_Series" : series]
        let urlString:String = vApiUrl + "/api/Video/Query"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let order:Int = resultDict["Video_Order"] as? Int ?? 0
                            let vimeoID:String = resultDict["Vimeo_ID"] as? String ?? ""
                            let series:String = resultDict["Video_Series"] as? String ?? ""
                            let name:String = resultDict["Video_Name"] as? String ?? ""
                            let imagUrl:String = resultDict["Thumbnail_ID"] as? String ?? ""
                            let v_type:String = resultDict["Video_Type"] as? String ?? ""
                            
                            videoOrderArray.append(order)
                            vimeoIDArray.append(vimeoID)
                            videoSeriesArray.append(series)
                            videoNameArray.append(name)
                            videoImageUrlArray.append(imagUrl)
                            videoTypeArray.append(v_type)
                            

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    resVideoDataArray = [videoOrderArray,vimeoIDArray,videoSeriesArray,videoNameArray,videoImageUrlArray,videoTypeArray]
                    
                    result(true,messageStr,resVideoDataArray)
                    
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
    
    func CGMGetVideoProductByID(vimeoID:String,result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Any>) -> Void) {
        
        
        var dataArray:Array<Array<Any>> = []
        var typeArray:Array<String> = []
        var modelArray:Array<String> = []
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673", "Vimeo_ID" : vimeoID]
        let urlString:String = vApiUrl + "/api/Video/QueryProduct"
        let url = URL.init(string: urlString)
        var messageStr:String = ""
        
        
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
  
                    let jsonInfo = json as? [String : Any] ?? [:]
                    let res:Int = jsonInfo["Result"] as? Int ?? 0
                    if res == 0 {

                        let pt1:String = jsonInfo["Product_Type_1"] as? String ?? ""
                        let pm1:String = jsonInfo["Product_Model_1"] as? String ?? ""
                        let pt2:String = jsonInfo["Product_Type_2"] as? String ?? ""
                        let pm2:String = jsonInfo["Product_Model_2"] as? String ?? ""
                        let pt3:String = jsonInfo["Product_Type_3"] as? String ?? ""
                        let pm3:String = jsonInfo["Product_Model_3"] as? String ?? ""
                        let pt4:String = jsonInfo["Product_Type_4"] as? String ?? ""
                        let pm4:String = jsonInfo["Product_Model_4"] as? String ?? ""
                        let pt5:String = jsonInfo["Product_Type_5"] as? String ?? ""
                        let pm5:String = jsonInfo["Product_Model_5"] as? String ?? ""
                        
                        if pt1 != "" && pm1 != "" {
                            typeArray.append(pt1)
                            modelArray.append(pm1)
                        }
                        if pt2 != "" && pm2 != "" {
                            typeArray.append(pt2)
                            modelArray.append(pm2)
                        }
                        if pt3 != "" && pm3 != "" {
                            typeArray.append(pt3)
                            modelArray.append(pm3)
                        }
                        if pt4 != "" && pm4 != "" {
                            typeArray.append(pt4)
                            modelArray.append(pm4)
                        }
                        if pt5 != "" && pm5 != "" {
                            typeArray.append(pt5)
                            modelArray.append(pm5)
                        }
                        
                        messageStr = jsonInfo["Message"] as? String ?? ""
                        
                        dataArray = [typeArray,modelArray]
                        
                        
                    }else{
                        
                        messageStr = jsonInfo["Message"] as? String ?? ""
                    }
                    
                    result(true,messageStr,dataArray)
                }else{
                    result(false,"",[])
                }
                
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"",[])
                
                break
            }
        }
    }
    
    
    //查詢食堂清單
    
    func CGMGetVideoCanteenList(result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) -> Void) {
        
        var videoSeriesArray:Array<String> = []
        var messageStr:String = ""

        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673"]
        let urlString:String = vApiUrl + "/api/Video/QueryVideo_Series"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let series:String = resultDict["Video_Series"] as? String ?? ""
                            videoSeriesArray.append(series)

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    result(true,messageStr,videoSeriesArray)
                    
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
    
    //查詢料理清單
    
    func CGMGetVideoFoodTypeList(result:@escaping (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) -> Void) {
        
        var videoTypeArray:Array<String> = []
        var messageStr:String = ""

        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673"]
        let urlString:String = vApiUrl + "/api/Video/QueryVideo_Type"
        let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                    let jsonArray:Array<Any> = json as? Array<Any> ?? []
                    
                    for i in 0 ..< jsonArray.count{
                        let resultDict = jsonArray[i] as? [String:Any] ?? [:]
                        let result:Int = resultDict["Result"] as? Int ?? 0
                        
                        if result == 0 {
                            let type:String = resultDict["Video_Type"] as? String ?? ""
                            videoTypeArray.append(type)

                        }else{
                            messageStr = resultDict["Message"] as? String ?? ""
                        }
                    }
                    
                    result(true,messageStr,videoTypeArray)
                    
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
    
    //MARK: - 官網
    
    func CGMGetVastarURLData(result:@escaping (_ isSuccess:Bool,_ message:String,_ resData:String) -> Void) {
        
        let headers:HTTPHeaders = ["Content-Type" : "application/json"]
        let parames:Parameters = ["UserID" : "vastar", "Password" : "vastar@2673"]
        let urlString:String = vApiUrl + "/api/Setting/GetVastarURL"
        let url = URL.init(string: urlString)
        var webUrl:String = ""
        Alamofire.request(url!, method: .post, parameters: parames, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (responseData:DataResponse<Any>) in
            switch (responseData.result) {
            case .success(let json):
                
                if responseData.response?.statusCode == 200 {
                    let jsonInfo = json as? [String : Any] ?? [:]
                    var messageStr:String = ""
                    let resStatus:Int = jsonInfo["Result"] as? Int ?? -1
                    if resStatus == 0 {
                        webUrl = jsonInfo["WebURL"] as? String ?? ""
                    }else{
                        messageStr = jsonInfo["Message"] as? String ?? ""
                    }
                    result(true,messageStr,webUrl)
                    
                }else{
                    result(false,"statusCode = \(String(describing: responseData.response?.statusCode))","")
                }
                break
            case .failure(let error):
                
                print("\(error)")
                result(false,"Error","")
                break
            }
        }
    }
    
}
