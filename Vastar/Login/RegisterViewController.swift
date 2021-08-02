//
//  RegisterViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/1.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPwTextField: UITextField!
    @IBOutlet var verifyCodeTextField: UITextField!
    
    @IBOutlet var verifyCodeBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var nameErrorLabel: UILabel!
    @IBOutlet var phoneErrorLabel: UILabel!
    @IBOutlet var pwErrorLabel: UILabel!
    @IBOutlet var confirmPwErrorLabel: UILabel!
    @IBOutlet var verifyErrorLabel: UILabel!
    
    private var verifyCode = 0
    private var verifyCodeSt = ""
    private var timer = Timer()
    private var defaultSec:Int = 30
    
    private var vaiv = VActivityIndicatorView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
    }
    
    
    //MARK: - UI Interface Methods
    
    // 設定UI介面
    
    func setInterface() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let placeHolderTextColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let textColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let lineColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 20.0)
        
        self.nameTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.nameTextField.setTextColor(textColor, font: font)
        
        self.phoneTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.phoneTextField.setTextColor(textColor, font: font)
        
        self.passwordTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.passwordTextField.setTextColor(textColor, font: font)
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.autocorrectionType = .no
        self.passwordTextField.keyboardType = .namePhonePad
        self.passwordTextField.textContentType = .username
        
        self.confirmPwTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.confirmPwTextField.setTextColor(textColor, font: font)
        self.confirmPwTextField.isSecureTextEntry = true
        self.confirmPwTextField.autocorrectionType = .no
        self.confirmPwTextField.keyboardType = .namePhonePad
        self.confirmPwTextField.textContentType = .username
        
        self.verifyCodeTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.verifyCodeTextField.setTextColor(textColor, font: font)
        self.verifyCodeTextField.keyboardType = .numberPad
        
        self.verifyCodeBtn.setTitle(NSLocalizedString("Register_Verify_Code_Btn_title", comment: ""), for: .normal)
        self.verifyCodeBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.verifyCodeBtn.addTarget(self, action: #selector(verifyCodeBtnClick(_:)), for: .touchUpInside)
        
        self.registerBtn.setTitle(NSLocalizedString("Register_Button_title", comment: ""), for: .normal)
        self.registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25.0)
        self.registerBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.registerBtn.addTarget(self, action: #selector(registerBtnClick(_:)), for: .touchUpInside)
        
        self.loginBtn.setTitle(NSLocalizedString("Register_Login_Btn_title", comment: ""), for: .normal)
        self.loginBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.loginBtn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
        
        self.nameErrorLabel.text = ""
        self.phoneErrorLabel.text = ""
        self.pwErrorLabel.text = ""
        self.confirmPwErrorLabel.text = ""
        self.verifyErrorLabel.text = ""
    }
    
    //MARK: - Assistant Methods
    
    // 建立註冊資料
    
    func createRegisterUserData(name:String,phone:String,pw:String) {
        
        let nowdate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDateString = dateFormatter.string(from: nowdate)
        print("==date = \(nowDateString)")
        
        var regDataDict:[String:Any] = [:]
        regDataDict.updateValue("vastar", forKey: "UserID")
        regDataDict.updateValue("vastar@2673", forKey: "Password")
        regDataDict.updateValue(phone, forKey: "Account_Name")
        regDataDict.updateValue(1, forKey: "Phone_Check")
        regDataDict.updateValue(name, forKey: "Name")
        regDataDict.updateValue(nowDateString, forKey: "RegisterTime")
        
        let newPassWord:String = "\(pw)\(nowDateString)"
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCRegisterUserByData(pw: newPassWord, regBodyDict: regDataDict) { (_ isSuccess:Bool,_ message:String) in
            
            if isSuccess {
            
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            }
        }
        
    }
    
    //檢查手機是否註冊過
    
    func checkRegisterPhone(phone:String,handler:@escaping ()->Void) {
        VClient.sharedInstance().VCGetUserInfoByPhone(phone: phone) { (_ isSuccess:Bool,_ message:String,_ isResult:Int,_ dictResData:[String:Any]) in
            if isSuccess {
                if isResult == 0 {
                    
                    let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
                    let font:UIFont = UIFont.systemFont(ofSize: 20.0)
                    let errorColor:UIColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
                    let color:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
                    
                    self.phoneErrorLabel.text = NSLocalizedString("Register_Phone_Exist_Alert_Text", comment: "")
                    self.phoneErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
                    self.phoneTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
                    self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: errorColor, font: font)
                    
                    self.nameErrorLabel.text = ""
                    self.nameTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
                    self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: color, font: font)
                    
                    self.pwErrorLabel.text = ""
                    self.passwordTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
                    self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: color, font: font)
                    
                    self.confirmPwErrorLabel.text = ""
                    self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
                    self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: color, font: font)
                    
                    self.verifyErrorLabel.text = ""
                    self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
                    self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: color, font: font)
                    
                }else{
                    handler()
                }
            }
        }
    }
    
    //檢查輸入資料
    
    func checkInputData() {
        
        let nameText = self.nameTextField.text ?? ""
        let phoneText = self.phoneTextField.text ?? ""
        let pwText = self.passwordTextField.text ?? ""
        let confirmPwText = self.confirmPwTextField.text ?? ""
        let veriftyCodeText = self.verifyCodeTextField.text ?? ""
        
        let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 20.0)
        let errorColor:UIColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        let color:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        
        if nameText.count == 0 {
            self.nameErrorLabel.text = NSLocalizedString("Register_Input_Name_Alert_Text", comment: "")
            self.nameErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.nameTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: errorColor, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: color, font: font)
            
            self.pwErrorLabel.text = ""
            self.passwordTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if phoneText.count == 0 {
            self.phoneErrorLabel.text = NSLocalizedString("Register_Input_Phone_Alert_Text", comment: "")
            self.phoneErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.phoneTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: errorColor, font: font)
            
            self.nameErrorLabel.text = ""
            self.nameTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: color, font: font)
            
            self.pwErrorLabel.text = ""
            self.passwordTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if pwText.count == 0 {
            self.pwErrorLabel.text = NSLocalizedString("Register_Input_Pw_Alert_Text", comment: "")
            self.pwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.passwordTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: errorColor, font: font)
            
            self.nameErrorLabel.text = ""
            self.nameTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: color, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if pwText.count < 8 {
            self.pwErrorLabel.text = NSLocalizedString("Register_Input_Pw_8_Alert_Text", comment: "")
            self.pwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.passwordTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: errorColor, font: font)
            
            self.nameErrorLabel.text = ""
            self.nameTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: color, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if confirmPwText.count == 0 {
            self.confirmPwErrorLabel.text = NSLocalizedString("Register_Input_Confirm_Pw_Alert_Text", comment: "")
            self.confirmPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.confirmPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: errorColor, font: font)
            
            self.nameErrorLabel.text = ""
            self.nameTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: color, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: color, font: font)
            
            self.pwErrorLabel.text = ""
            self.passwordTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if pwText != confirmPwText {
            self.confirmPwErrorLabel.text = NSLocalizedString("Register_Input_diff_Alert_Text", comment: "")
            self.confirmPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.confirmPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: errorColor, font: font)
            
            self.nameErrorLabel.text = ""
            self.nameTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: color, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: color, font: font)
            
            self.pwErrorLabel.text = ""
            self.passwordTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: color, font: font)
            
            self.verifyErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: color, font: font)
            
        }else if veriftyCodeText.count == 0 {
            
            self.verifyErrorLabel.text = NSLocalizedString("Register_Input_VeriftyCode_Alert_Text", comment: "")
            self.verifyErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.verifyCodeTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: errorColor, font: font)
            
            self.nameErrorLabel.text = ""
            self.nameTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: color, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: color, font: font)
            
            self.pwErrorLabel.text = ""
            self.passwordTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: color, font: font)
            
            
        }else if veriftyCodeText != verifyCodeSt {
            
            self.verifyErrorLabel.text = NSLocalizedString("Register_Input_VeriftyCode_Error_Alert_Text", comment: "")
            self.verifyErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.verifyCodeTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Verify_Code_title", comment: ""), colour: errorColor, font: font)
            
            self.nameErrorLabel.text = ""
            self.nameTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Name_title", comment: ""), colour: color, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Phone_title", comment: ""), colour: color, font: font)
            
            self.pwErrorLabel.text = ""
            self.passwordTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Password_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Register_Confirm_Password_title", comment: ""), colour: color, font: font)
            
        }else {
            
            self.checkRegisterPhone(phone: phoneText) {
                self.createRegisterUserData(name: nameText, phone: phoneText, pw: pwText)
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
                self.verifyCodeBtn.setTitle(NSLocalizedString("Register_Verify_Code_Btn_title", comment: ""), for: .normal)
            }else{
                self.defaultSec = self.defaultSec-1
                self.verifyCodeBtn.setTitle("\(self.defaultSec)\(NSLocalizedString("Register_Verify_Wait_Btn_title", comment: ""))", for: .normal)
                
            }
        })
        
    }
    
    func stopTimer() {
        self.timer.invalidate()
        self.defaultSec = 30
    }
    
    
    
    //MARK: - Action
    
    @objc func verifyCodeBtnClick(_ sender:UIButton){
        
        let phoneText = self.phoneTextField.text ?? ""
        if phoneText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Register_Input_Phone_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
        }else if phoneText.count < 10 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Register_Input_Phone_10_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
        }else{
            self.verifyCodeBtn.isEnabled = false
            sendMMS(phone: phoneText)
        }
    }
    
    @objc func registerBtnClick(_ sender:UIButton){
        
        checkInputData()
    }
    
    @objc func loginBtnClick(_ sender:UIButton){
        
        self.dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
