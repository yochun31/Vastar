//
//  ChangePwViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/7.
//

import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

protocol ChangePwViewDelegate {
    func goVc()
}

class ChangePwViewController: UIViewController,CustomAlertViewDelegate {

    @IBOutlet var oldPwTextField: UITextField!
    @IBOutlet var newPwTextField: UITextField!
    @IBOutlet var confirmPwTextField: UITextField!
    @IBOutlet var verifyCodeTextField: UITextField!
    
    
    @IBOutlet var verifyCodeBtn: UIButton!
    @IBOutlet var confirmBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var oldPwErrorLabel: UILabel!
    @IBOutlet var nPwErrorLabel: UILabel!
    @IBOutlet var confirmPwErrorLabel: UILabel!
    @IBOutlet var verifyErrorLabel: UILabel!
    
    private var userResgisterTime:String = ""
    private var vaiv = VActivityIndicatorView()
    private var cav = CustomAlertView()
    
    private var verifyCode = 0
    private var verifyCodeSt = ""
    private var timer = Timer()
    private var defaultSec:Int = 30
    
    let userDefault = UserDefaults.standard
    
    var delegate:ChangePwViewDelegate?
    var accountPhone:String = ""
    

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLeftBarButton()
        setInterface()
        setupSWReveal()
    }
    
    
    //MARK: - UI Interface Methods
    
    // 設定Navigation左側按鈕
    
    func setLeftBarButton() {
        let leftBarBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBarBtn.setImage(UIImage(named: "menu"), for: .normal)
        leftBarBtn.addTarget(self, action: #selector(leftBarBtnClick(_:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem(customView: leftBarBtn)
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func setupSWReveal(){
        //adding panGesture to reveal menu controller
        view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        //adding tap gesture to hide menu controller
        view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        //setting reveal width of menu controller manually
        self.revealViewController()?.rearViewRevealWidth = UIScreen.main.bounds.width * (2/3)
    }
    
    // 設定UI介面
    
    func setInterface() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.navigationItem.title = NSLocalizedString("Change_Pw_title", comment: "")
        
        let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let placeHolderTextColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let textColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let lineColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 20.0)
        
        self.oldPwTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.oldPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Old_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.oldPwTextField.setTextColor(textColor, font: font)
        self.oldPwTextField.isSecureTextEntry = true
        
        self.newPwTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.newPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_New_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.newPwTextField.setTextColor(textColor, font: font)
        self.newPwTextField.isSecureTextEntry = true
        
        self.confirmPwTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Confirm_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.confirmPwTextField.setTextColor(textColor, font: font)
        self.confirmPwTextField.isSecureTextEntry = true
        
        self.verifyCodeTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Verify_Code_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.verifyCodeTextField.setTextColor(textColor, font: font)
        
        self.verifyCodeBtn.setTitle(NSLocalizedString("Change_Pw_Verify_Code_Btn_title", comment: ""), for: .normal)
        self.verifyCodeBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.verifyCodeBtn.addTarget(self, action: #selector(verifyCodeBtnClick(_:)), for: .touchUpInside)
        
        self.confirmBtn.setTitle(NSLocalizedString("Change_Pw_Confirm_Btn_title", comment: ""), for: .normal)
        self.confirmBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick(_:)), for: .touchUpInside)
        
        self.cancelBtn.setTitle(NSLocalizedString("Change_Pw_Cancel_Btn_title", comment: ""), for: .normal)
        self.cancelBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        
        self.oldPwErrorLabel.text = ""
        self.nPwErrorLabel.text = ""
        self.confirmPwErrorLabel.text = ""
        self.verifyErrorLabel.text = ""
    }
    
    
    //MARK: - Assistant Methods
    
    // 取得帳號資料
    
    func getUserInfo(accountName:String,oldPwSt:String,newPwSt:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        
        VClient.sharedInstance().VCGetUserInfoByPhone(phone: accountName) { (_ isSuccess:Bool,_ message:String,_ isResult:Int,_ dictResData:[String:Any]) in
            
            if isSuccess {
                if isResult == 0 {
                    let res_registerTime = dictResData["RegisterTime"] as? String ?? ""
                    let registerTimeArray = res_registerTime.split(separator: ".")
                    self.userResgisterTime = String(registerTimeArray[0])
                    
                    let oldPassWord:String = "\(oldPwSt)\(self.userResgisterTime)"
                    let newPassWord:String = "\(newPwSt)\(self.userResgisterTime)"
                    self.updateChangePw(phone: accountName, oldPw: oldPassWord, newPw: newPassWord)
                }
                
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
    }
    
    // 更新密碼
    
    func updateChangePw(phone:String,oldPw:String,newPw:String) {
        
        VClient.sharedInstance().VCUpdateChangePw(phone: phone, oldPw: oldPw, newPw: newPw) { (_ isSuccess:Bool,_ message:String) in
            
            if isSuccess {
                print(">>\(message)<<")
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: NSLocalizedString("Change_Pw_Update_Success_Alert_Text", comment: ""), btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 1, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
        
    }
    
    // 檢查舊密碼時否正確
    
    func checkOldPW(pwSt:String,handler:@escaping ()->Void) {
        
        let md5Data = self.MD5_String(string:pwSt)
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        print("---\(md5Hex)")
        let oldPw:String = self.userDefault.object(forKey: "A1") as? String ?? ""
        
        if oldPw == md5Hex {
            handler()
        }else{
            let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
            let font:UIFont = UIFont.systemFont(ofSize: 20.0)
            let errorColor:UIColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            let color:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
            
            self.oldPwErrorLabel.text = NSLocalizedString("Change_Pw_Input_Old_Error_Alert_Text", comment: "")
            self.oldPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.oldPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.oldPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Old_title", comment: ""), colour: errorColor, font: font)
            

            self.nPwErrorLabel.text = ""
            self.newPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.newPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Confirm_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Verify_Code_title", comment: ""), colour: color, font: font)
        }
    }
    
    // 檢查輸入資料
    
    func checkInputData() {
        
        let oldPwText = self.oldPwTextField.text ?? ""
        let newPwText = self.newPwTextField.text ?? ""
        let confirmPwText = self.confirmPwTextField.text ?? ""
        let veriftyCodeText = self.verifyCodeTextField.text ?? ""
        
        let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 20.0)
        let errorColor:UIColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        let color:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        if oldPwText.count == 0 {
            self.oldPwErrorLabel.text = NSLocalizedString("Change_Pw_Input_Old_Alert_Text", comment: "")
            self.oldPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.oldPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.oldPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Old_title", comment: ""), colour: errorColor, font: font)
            

            self.nPwErrorLabel.text = ""
            self.newPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.newPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Confirm_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if newPwText.count == 0 {
            self.nPwErrorLabel.text = NSLocalizedString("Change_Pw_Input_New_Alert_Text", comment: "")
            self.nPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.newPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.newPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_New_title", comment: ""), colour: errorColor, font: font)
            
            self.oldPwErrorLabel.text = ""
            self.oldPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.oldPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Old_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Confirm_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if newPwText.count < 8 {
            self.nPwErrorLabel.text = NSLocalizedString("Change_Pw_Input_Pw_8_Alert_Text", comment: "")
            self.nPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.newPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.newPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_New_title", comment: ""), colour: errorColor, font: font)
            
            self.oldPwErrorLabel.text = ""
            self.oldPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.oldPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Old_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Confirm_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if confirmPwText.count == 0 {
            self.confirmPwErrorLabel.text = NSLocalizedString("Change_Pw_Input_Confirm_Pw_Alert_Text", comment: "")
            self.confirmPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.confirmPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Confirm_title", comment: ""), colour: errorColor, font: font)
            
            self.oldPwErrorLabel.text = ""
            self.oldPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.oldPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Old_title", comment: ""), colour: color, font: font)
            
            self.nPwErrorLabel.text = ""
            self.newPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.newPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if confirmPwText != newPwText {
            self.confirmPwErrorLabel.text = NSLocalizedString("Change_Pw_Input_diff_Alert_Text", comment: "")
            self.confirmPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.confirmPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Confirm_title", comment: ""), colour: errorColor, font: font)
            
            self.oldPwErrorLabel.text = ""
            self.oldPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.oldPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Old_title", comment: ""), colour: color, font: font)
            
            self.nPwErrorLabel.text = ""
            self.newPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.newPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if veriftyCodeText.count == 0 {
            self.verifyErrorLabel.text = NSLocalizedString("Change_Pw_Input_VeriftyCode_Alert_Text", comment: "")
            self.verifyErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.verifyCodeTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Verify_Code_title", comment: ""), colour: errorColor, font: font)
            
            self.oldPwErrorLabel.text = ""
            self.oldPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.oldPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Old_title", comment: ""), colour: color, font: font)
            
            self.nPwErrorLabel.text = ""
            self.newPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.newPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Confirm_title", comment: ""), colour: color, font: font)
            
        }else if veriftyCodeText != verifyCodeSt {
            self.verifyErrorLabel.text = NSLocalizedString("Change_Pw_VeriftyCode_Error_Alert_Text", comment: "")
            self.verifyErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.verifyCodeTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Verify_Code_title", comment: ""), colour: errorColor, font: font)
            
            self.oldPwErrorLabel.text = ""
            self.oldPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.oldPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Old_title", comment: ""), colour: color, font: font)
            
            self.nPwErrorLabel.text = ""
            self.newPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.newPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Change_Pw_Confirm_title", comment: ""), colour: color, font: font)
            
        }else{
            
            self.checkOldPW(pwSt: oldPwText) {
                self.getUserInfo(accountName: self.accountPhone, oldPwSt: oldPwText, newPwSt: newPwText)
            }
            
        }
        
    }
    
    // 簡訊驗證碼產生
    
    func sendMMS(phone:String) {
        verifyCode = Int.random(in: 0000...9999)
        verifyCodeSt = String(format: "%04d", verifyCode)
        print("--->SMS code = \(verifyCodeSt)")
        VClient.sharedInstance().VCSendMMSVerify(sendPhone: phone, code: verifyCodeSt) { isSuccess in
            if isSuccess {
                self.setVerifyBtn()
            }
        }
    }
    
    // 設定簡訊驗證按鈕
    
    func setVerifyBtn() {
    
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            if self.defaultSec == 0 {
                self.verifyCodeBtn.isEnabled = true
                self.stopTimer()
                self.verifyCodeBtn.setTitle(NSLocalizedString("Change_Pw_Verify_Code_Btn_title", comment: ""), for: .normal)
            }else{
                self.defaultSec = self.defaultSec-1
                self.verifyCodeBtn.setTitle("\(self.defaultSec)\(NSLocalizedString("Change_Pw_Verify_Wait_Btn_title", comment: ""))", for: .normal)
                
            }
        })
        
    }
    
    func stopTimer() {
        self.timer.invalidate()
        self.defaultSec = 30
    }
    
    // MD5加密
    
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
    
    
    //MARK: - Action
    
    @objc func leftBarBtnClick(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    @objc func confirmBtnClick(_ sender:UIButton) {
        
        checkInputData()
    }
    
    @objc func cancelBtnClick(_ sender:UIButton) {
        
        let nav = UINavigationController()
        let reveal = self.revealViewController()
        let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
        nav.viewControllers = [vc]
        reveal?.pushFrontViewController(nav, animated: true)
    }
    
    @objc func verifyCodeBtnClick(_ sender:UIButton) {
        self.verifyCodeBtn.isEnabled = false
        sendMMS(phone: self.accountPhone)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - CustomAlertViewDelegate
    
    func alertBtnClick(btnTag: Int) {
        
        if btnTag == 1 {
            self.cav.removeFromSuperview()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }else{
            self.cav.removeFromSuperview()
        }
        
    }

}
