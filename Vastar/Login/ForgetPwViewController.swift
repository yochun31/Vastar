//
//  ForgetPwViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/1.
//

import UIKit

class ForgetPwViewController: UIViewController {

    
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var nPwTextField: UITextField!
    @IBOutlet var confirmPwTextField: UITextField!
    @IBOutlet var verifyCodeTextField: UITextField!
    
    @IBOutlet var verifyCodeBtn: UIButton!
    @IBOutlet var confirmBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var phoneErrorLabel: UILabel!
    @IBOutlet var nPwErrorLabel: UILabel!
    @IBOutlet var confirmPwErrorLabel: UILabel!
    @IBOutlet var verifyCodeErrorLabel: UILabel!
    
    
    private var userResgisterTime:String = ""
    private var vaiv = VActivityIndicatorView()
    
    private var verifyCode = 0
    private var verifyCodeSt = ""
    private var timer = Timer()
    private var defaultSec:Int = 30
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        self.phoneTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.phoneTextField.setTextColor(textColor, font: font)
        
        self.nPwTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.nPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_New_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.nPwTextField.setTextColor(textColor, font: font)
        self.nPwTextField.isSecureTextEntry = true
        self.nPwTextField.autocorrectionType = .no
        self.nPwTextField.keyboardType = .namePhonePad
        
        self.confirmPwTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Confirm_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.confirmPwTextField.setTextColor(textColor, font: font)
        self.confirmPwTextField.isSecureTextEntry = true
        self.confirmPwTextField.autocorrectionType = .no
        self.confirmPwTextField.keyboardType = .namePhonePad
        
        self.verifyCodeTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Verify_Code_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.verifyCodeTextField.setTextColor(textColor, font: font)
        self.verifyCodeTextField.keyboardType = .numberPad

        self.verifyCodeBtn.setTitle(NSLocalizedString("Forget_Verify_Code_Btn_title", comment: ""), for: .normal)
        self.verifyCodeBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.verifyCodeBtn.addTarget(self, action: #selector(verifyCodeBtnClick(_:)), for: .touchUpInside)
        
        
        self.confirmBtn.setTitle(NSLocalizedString("Forget_Confirm_Btn_title", comment: ""), for: .normal)
        self.confirmBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick(_:)), for: .touchUpInside)
        
        self.cancelBtn.setTitle(NSLocalizedString("Forget_Cancel_Btn_title", comment: ""), for: .normal)
        self.cancelBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        
        
        self.phoneErrorLabel.text = ""
        self.nPwErrorLabel.text = ""
        self.confirmPwErrorLabel.text = ""
        self.verifyCodeErrorLabel.text = ""
    }
    
    //MARK: - Assistant Methods
    
    func getUserInfo(accountName:String,pw:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        
        VClient.sharedInstance().VCGetUserInfoByPhone(phone: accountName) { (_ isSuccess:Bool,_ message:String,_ isResult:Int,_ dictResData:[String:Any]) in
            
            if isSuccess {
                let res_registerTime = dictResData["RegisterTime"] as? String ?? ""
                let registerTimeArray = res_registerTime.split(separator: ".")
                self.userResgisterTime = String(registerTimeArray[0])
                
                let newPassWord:String = "\(pw)\(self.userResgisterTime)"
                self.updateForgetPw(phone: accountName, newPw: newPassWord)

            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                    
                }
            }
        }
    }
    
    func updateForgetPw(phone:String,newPw:String) {
        
        VClient.sharedInstance().VCUpdateForgetPw(phone: phone, newPw: newPw) { (_ isSuccess:Bool,_ message:String) in
            if isSuccess {
                
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Update_Success_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            }
        }
    }
    
    //檢查輸入資料
    
    func checkIputData() {
        let phoneText = self.phoneTextField.text ?? ""
        let nPwText = self.nPwTextField.text ?? ""
        let confirmPwText = self.confirmPwTextField.text ?? ""
        let veriftyCodeText = self.verifyCodeTextField.text ?? ""
        
        let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 20.0)
        let errorColor:UIColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        let color:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        if phoneText.count == 0 {
            self.phoneErrorLabel.text = NSLocalizedString("Forget_Input_Phone_Alert_Text", comment: "")
            self.phoneErrorLabel.textColor = errorColor
            
            self.phoneTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: errorColor, font: font)

            self.nPwErrorLabel.text = ""
            self.confirmPwErrorLabel.text = ""
            self.verifyCodeErrorLabel.text = ""

        }else if phoneText.count < 10 {
            self.phoneErrorLabel.text = NSLocalizedString("Forget_Input_Phone_10_Alert_Text", comment: "")
            self.phoneErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.phoneTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: errorColor, font: font)


            self.nPwErrorLabel.text = ""
            self.confirmPwErrorLabel.text = ""
            self.verifyCodeErrorLabel.text = ""

        }else if nPwText.count == 0 {
            self.nPwErrorLabel.text = NSLocalizedString("Forget_Input_Pw_Alert_Text", comment: "")
            self.nPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.nPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.nPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_New_title", comment: ""), colour: errorColor, font: font)

            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Confirm_title", comment: ""), colour: color, font: font)
            
            self.verifyCodeErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Verify_Code_title", comment: ""), colour: color, font: font)

        }else if nPwText.count < 8 {
            self.nPwErrorLabel.text = NSLocalizedString("Forget_Input_Pw_8_Alert_Text", comment: "")
            self.nPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.nPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.nPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_New_title", comment: ""), colour: errorColor, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Confirm_title", comment: ""), colour: color, font: font)
            
            self.verifyCodeErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Verify_Code_title", comment: ""), colour: color, font: font)

        }else if confirmPwText.count == 0 {
            self.confirmPwErrorLabel.text = NSLocalizedString("Forget_Input_Confirm_Pw_Alert_Text", comment: "")
            self.confirmPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.confirmPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Confirm_title", comment: ""), colour: errorColor, font: font)
            
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: color, font: font)
            
            self.nPwErrorLabel.text = ""
            self.nPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.verifyCodeErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Verify_Code_title", comment: ""), colour: color, font: font)

        }else if nPwText != confirmPwText {
            self.confirmPwErrorLabel.text = NSLocalizedString("Forget_Input_diff_Alert_Text", comment: "")
            self.confirmPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            self.confirmPwTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Confirm_title", comment: ""), colour: errorColor, font: font)
            
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: color, font: font)
            
            self.nPwErrorLabel.text = ""
            self.nPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.verifyCodeErrorLabel.text = ""
            self.verifyCodeTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Verify_Code_title", comment: ""), colour: color, font: font)

        }else if veriftyCodeText.count == 0 {
            self.verifyCodeErrorLabel.text = NSLocalizedString("Forget_Input_VeriftyCode_Alert_Text", comment: "")
            self.verifyCodeErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.verifyCodeTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Verify_Code_title", comment: ""), colour: errorColor, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: color, font: font)
            
            self.nPwErrorLabel.text = ""
            self.nPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Confirm_title", comment: ""), colour: color, font: font)

        }else if veriftyCodeText != verifyCodeSt {
            self.verifyCodeErrorLabel.text = NSLocalizedString("Forget_Input_VeriftyCode_Error_Alert_Text", comment: "")
            self.verifyCodeErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.verifyCodeTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.verifyCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Verify_Code_title", comment: ""), colour: errorColor, font: font)
            
            self.phoneErrorLabel.text = ""
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: color, font: font)
            
            self.nPwErrorLabel.text = ""
            self.nPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.nPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_New_title", comment: ""), colour: color, font: font)
            
            self.confirmPwErrorLabel.text = ""
            self.confirmPwTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)
            self.confirmPwTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Confirm_title", comment: ""), colour: color, font: font)

        }else{

            self.getUserInfo(accountName: phoneText, pw: nPwText)
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
                self.verifyCodeBtn.setTitle(NSLocalizedString("Forget_Verify_Code_Btn_title", comment: ""), for: .normal)
            }else{
                self.defaultSec = self.defaultSec-1
                self.verifyCodeBtn.setTitle("\(self.defaultSec)\(NSLocalizedString("Forget_Verify_Wait_Btn_title", comment: ""))", for: .normal)
                
            }
        })
        
    }
    
    func stopTimer() {
        self.timer.invalidate()
        self.defaultSec = 30
    }
    
    
    
    
    //MARK: - Action
    
    @objc func verifyCodeBtnClick(_ sender:UIButton) {
        
        let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 20.0)
        let errorColor:UIColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        let color:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        let phoneText = self.phoneTextField.text ?? ""
        if phoneText.count == 0 {

            self.phoneErrorLabel.text = NSLocalizedString("Forget_Input_Phone_Alert_Text", comment: "")
            self.phoneErrorLabel.textColor = errorColor
            
            self.phoneTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: errorColor, font: font)

            self.nPwErrorLabel.text = ""
            self.confirmPwErrorLabel.text = ""
            self.verifyCodeErrorLabel.text = ""
            
        }else if phoneText.count < 10 {
            self.phoneErrorLabel.text = NSLocalizedString("Forget_Input_Phone_10_Alert_Text", comment: "")
            self.phoneErrorLabel.textColor = errorColor
            
            self.phoneTextField.setBottomBorder(with: errorColor, width: 1.0, bkColor: backgroundColor)
            self.phoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Forget_Pw_Phone_title", comment: ""), colour: errorColor, font: font)

            self.nPwErrorLabel.text = ""
            self.confirmPwErrorLabel.text = ""
            self.verifyCodeErrorLabel.text = ""
        }else{
            self.verifyCodeBtn.isEnabled = false
            self.phoneErrorLabel.text = ""
            self.phoneErrorLabel.textColor = color
            self.phoneTextField.setBottomBorder(with: color, width: 1.0, bkColor: backgroundColor)

            sendMMS(phone: phoneText)
        }
        
    }
    
    @objc func confirmBtnClick(_ sender:UIButton) {
        
        checkIputData()
    }
    
    @objc func cancelBtnClick(_ sender:UIButton) {
        
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
