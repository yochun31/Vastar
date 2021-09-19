//
//  TransactionViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/9/7.
//

import UIKit
import WebKit
import CryptoSwift
import SwiftyRSA

class TransactionViewController: UIViewController,WKNavigationDelegate,CustomAlertViewDelegate {

    @IBOutlet var transactionWebView: WKWebView!
    
    private var cav = CustomAlertView()
    private var vaiv = VActivityIndicatorView()
    private var isDoneFlag:Bool = false
    
//    private let MchId = "S2PT90000"//test
//    private let TradeKey = "c4fe6b6dbe94790f232013154cb80fc5dd3ec9106d433492f20f038b1ce25656"//test
    private let MchId = "a89441183"
    private let TradeKey = "3b06c292b902a53ba8d7d58e1423c753616a69fee13a54a292022743f0f36d5f"
    private let RefundKey = "13b7994fae9387c2e1b598524ba1204ae404d02fa67016ed86c74183ab1aafca"
    private let EZCDeviceId = "01304178"
    
    var turl:String = ""
    var orderNo:String = ""
    var getUrl_OrderNo:String = ""
    var totalPayPrice:Int = 0
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "付款"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(leftbackBtnClick(_:)))
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.transactionWebView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getTransactionURL(orderNo: self.getUrl_OrderNo)
    }
    
    // MARK: - Assistant Methods
    
    
    func getTransactionURL(orderNo:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Login_ActivityIndicatorView_title", comment: ""))
        
        let reqHeader = NSMutableDictionary()
        reqHeader.setValue("23900", forKey: "Method")
        reqHeader.setValue("OLPay", forKey: "ServiceType")
        reqHeader.setValue(MchId, forKey: "MchId")
        reqHeader.setValue(TradeKey, forKey: "TradeKey")

        let currentTime = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYYMMddHHmmss"
        reqHeader.setValue(dateFormat.string(from: currentTime), forKey: "CreateTime")
        
        let reqData = NSMutableDictionary()
        reqData.setValue(EZCDeviceId, forKey: "DeviceId")
        reqData.setValue("0", forKey: "Retry")
        reqData.setValue("飛騰相關商品", forKey: "Body")
        reqData.setValue("skb0001", forKey: "DeviceInfo")
        reqData.setValue(orderNo, forKey: "StoreOrderNo")
        reqData.setValue("TWD", forKey: "FeeType")
        reqData.setValue(1, forKey: "DeviceOS")
        reqData.setValue(self.totalPayPrice, forKey: "TotalFee")
        

        var jsonDataText = ""
        if let jsonData = try? JSONSerialization.data(withJSONObject: reqData, options: [])
        {
            jsonDataText = String(data: jsonData, encoding: .utf8)!
        }
        //print("JSON string = \(jsonDataText)")
        
        let request = NSMutableDictionary()
        request.setValue(reqHeader, forKey: "Header")
        request.setValue(jsonDataText, forKey: "Data")
        
        var jsonRequestText = ""
        if let jsonRequest = try? JSONSerialization.data(withJSONObject: request, options: [])
        {
            jsonRequestText = String(data: jsonRequest, encoding: .utf8)!
        }
        print("JSON string = \(jsonRequestText)")
        
        do
        {
            print("33333333")
            let aesKey = "intella.co.test1"
            let aesIV = "8651731586517315"
            let aes = try AES(key: aesKey.bytes, blockMode: CBC(iv: aesIV.bytes))
            
            let encrypted = try aes.encrypt(jsonRequestText.bytes)
            let encryptedBase64 = encrypted.toBase64()
            //print("encryptedBase64=\(encryptedBase64)")
            
            let aesKeyBase64 = aesKey.bytes.toBase64()
            print("aesKeyBase64=\(aesKeyBase64)")
            
//            let publicKey = try PublicKey(pemNamed: "stage-public")
            let publicKey = try PublicKey(pemNamed: "pub")
            let clear = try ClearMessage(string: aesKeyBase64, using: .ascii)
            let apiKey = try clear.encrypted(with: publicKey, padding: .PKCS1)
            let apiKeyBase64 = apiKey.base64String
            print("apiKeyBase64=\(apiKeyBase64))")
            
            var finalRequest:[String:String] = [:]
            finalRequest.updateValue(encryptedBase64, forKey: "Request")
            finalRequest.updateValue(apiKeyBase64, forKey: "ApiKey")
            print("==>\(finalRequest)")
            VClient.sharedInstance().VCGetTransactionUrl(reqBodyDict: finalRequest) {(_ isSuccess:Bool,_ message:String,_ resString:String) in
                
                if isSuccess {
                    print("-----\(resString)")
                    
                    do {
                        
                        let rspBytes = Data(base64Encoded: resString)!
                        let decrypted = try aes.decrypt([UInt8](rspBytes))
                        let decryptedData = Data(decrypted)
                        let finalResponse:String = String(bytes: decryptedData.bytes, encoding: .utf8) ?? ""
                        print("Response = \(finalResponse)")
                        self.ParseJsonGetURL(jsonSt: finalResponse)
                    }
                    catch {}
                }
                
            }
            
        } catch{}
    }
    
    func ParseJsonGetURL(jsonSt:String) {
        
        if let data = jsonSt.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                
                let jsonInfo:[String:Any] = json ?? [:]
                let json_Data = jsonInfo["Data"] as? [String : Any] ?? [:]
                let urlToken:String = json_Data["urlToken"] as? String ?? ""
                
//                if let url = URL(string: urlToken) {
//                    UIApplication.shared.open(url)
//                }

                self.loadWebView(url: urlToken)
                print("=> \(urlToken)")

            } catch {
                print("Something went wrong")
            }
        }
    }
    
    
    func loadWebView(url:String) {
        self.transactionWebView.navigationDelegate = self
        if let u = URL(string: url) {
            let request = URLRequest(url: u)
            self.transactionWebView.configuration.preferences.javaScriptEnabled = true
            self.transactionWebView.load(request)
            
        }
    }
    
    func checkoutStatus(url:String) {
        
        if url.contains("交易成功") {
            self.updateOrderStatus()
            isDoneFlag = true
        }else{
            isDoneFlag = false
        }
    }
    
    func updateOrderStatus() {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Login_ActivityIndicatorView_title", comment: ""))
        
        VClient.sharedInstance().VCUpdateOrderStatus(orderNo: self.orderNo, status: NSLocalizedString("Order_Pay_Done_text", comment: "")) { (_ isSuccess:Bool,_ message:String) in
            if isSuccess {
                self.vaiv.stopProgressHUD(view: self.view)
                print(">>>\(message)")
                
                
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                
                self.cav = CustomAlertView.init(title: message, btnTitle:NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
    }
    
    // MARK: - Action
    
    @objc func leftbackBtnClick(_ sender:UIButton) {
        
        if isDoneFlag {
            let vc = SuccessInfoViewController(nibName: "SuccessInfoViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
            let vc = FailInfoViewController(nibName: "FailInfoViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
                                    
                                    let htmlSt:String = html as? String ?? ""
                                    print(">>>>>\(htmlSt)")
                                    self.checkoutStatus(url: htmlSt)
                                   })

//        if let url = webView.url?.absoluteString{
//
//            let urlSt:String = url.decodeUrl() ?? ""
//            print("====> url = \(urlSt)")
//
//        }
//
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){

        vaiv.stopProgressHUD(view: self.view)

    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            let headers = response.allHeaderFields
            //do something with headers
            
            
            print("---!> \(headers)")
        }
        decisionHandler(.allow)
    }
    
    //MARK: - CustomAlertViewDelegate
    
    func alertBtnClick(btnTag: Int) {
        self.cav.removeFromSuperview()
    }

}

extension String
{
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}
