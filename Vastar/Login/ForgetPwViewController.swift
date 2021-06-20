//
//  ForgetPwViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/1.
//

import UIKit

class ForgetPwViewController: UIViewController {

    
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var newPwTextField: UITextField!
    @IBOutlet var confirmPwTextField: UITextField!
    @IBOutlet var verifyCodeTextField: UITextField!
    
    @IBOutlet var verifyCodeBtn: UIButton!
    @IBOutlet var confirmBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
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
    
    func setInterface() {
        
        self.phoneTextField.placeholder = NSLocalizedString("Forget_Pw_Phone_title", comment: "")
        
        self.newPwTextField.placeholder = NSLocalizedString("Forget_Pw_New_title", comment: "")
        self.newPwTextField.isSecureTextEntry = true
        
        self.confirmPwTextField.placeholder = NSLocalizedString("Forget_Pw_Confirm_title", comment: "")
        self.confirmPwTextField.isSecureTextEntry = true
        
        self.verifyCodeTextField.placeholder = NSLocalizedString("Forget_Verify_Code_title", comment: "")
        
        self.verifyCodeBtn.setTitle(NSLocalizedString("Forget_Verify_Code_Btn_title", comment: ""), for: .normal)
        self.verifyCodeBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.verifyCodeBtn.addTarget(self, action: #selector(verifyCodeBtnClick(_:)), for: .touchUpInside)
        
        
        self.confirmBtn.setTitle(NSLocalizedString("Forget_Confirm_Btn_title", comment: ""), for: .normal)
        self.confirmBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick(_:)), for: .touchUpInside)
        
        self.cancelBtn.setTitle(NSLocalizedString("Forget_Cancel_Btn_title", comment: ""), for: .normal)
        self.cancelBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
    }
    
    //MARK: - Assistant Methods
    
    func getUserInfo(accountName:String,pw:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        
        VClient.sharedInstance().VCGetUserInfoByPhone(phone: accountName) { (_ isSuccess:Bool,_ message:String,_ dictResData:[String:Any]) in
            
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
    
    
    func checkIputData() {
        let phoneText = self.phoneTextField.text ?? ""
        let newPwText = self.newPwTextField.text ?? ""
        let confirmPwText = self.confirmPwTextField.text ?? ""
        let veriftyCodeText = self.verifyCodeTextField.text ?? ""
        
        if phoneText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Input_Phone_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
        }else if newPwText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Input_Pw_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if newPwText.count < 8 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Input_Pw_8_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
        
        }else if confirmPwText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Input_Confirm_Pw_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if newPwText != confirmPwText {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Input_diff_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if veriftyCodeText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Input_VeriftyCode_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if veriftyCodeText != verifyCodeSt {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Input_VeriftyCode_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else{
            
            self.getUserInfo(accountName: phoneText, pw: newPwText)
        }
    }
    
    
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
        
        let phoneText = self.phoneTextField.text ?? ""
        if phoneText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Input_Phone_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
        }else if phoneText.count < 10 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Forget_Input_Phone_10_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
        }else{
            self.verifyCodeBtn.isEnabled = false
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
