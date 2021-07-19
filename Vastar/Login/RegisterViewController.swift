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
    
    
    private var vaiv = VActivityIndicatorView()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
    }
    
    
    //MARK: - UI Interface Methods
    
    func setInterface() {
        
        self.nameTextField.placeholder = NSLocalizedString("Register_Name_title", comment: "")
        
        self.phoneTextField.placeholder = NSLocalizedString("Register_Phone_title", comment: "")
        
        self.passwordTextField.placeholder = NSLocalizedString("Register_Password_title", comment: "")
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.autocorrectionType = .no
        self.passwordTextField.keyboardType = .namePhonePad
        self.passwordTextField.textContentType = .username
        
        self.confirmPwTextField.placeholder = NSLocalizedString("Register_Confirm_Password_title", comment: "")
        self.confirmPwTextField.isSecureTextEntry = true
        self.confirmPwTextField.autocorrectionType = .no
        self.confirmPwTextField.keyboardType = .namePhonePad
        self.confirmPwTextField.textContentType = .username
        
        self.verifyCodeTextField.placeholder = NSLocalizedString("Register_Verify_Code_title", comment: "")
        
        self.verifyCodeBtn.setTitle(NSLocalizedString("Register_Verify_Code_Btn_title", comment: ""), for: .normal)
        self.verifyCodeBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.verifyCodeBtn.addTarget(self, action: #selector(verifyCodeBtnClick(_:)), for: .touchUpInside)
        
        self.registerBtn.setTitle(NSLocalizedString("Register_Button_title", comment: ""), for: .normal)
        self.registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25.0)
        self.registerBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.registerBtn.addTarget(self, action: #selector(registerBtnClick(_:)), for: .touchUpInside)
        
        self.loginBtn.setTitle(NSLocalizedString("Register_Login_Btn_title", comment: ""), for: .normal)
        self.loginBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.loginBtn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
        
        self.nameErrorLabel.text = ""
        self.phoneErrorLabel.text = ""
        self.pwErrorLabel.text = ""
        self.confirmPwErrorLabel.text = ""
        self.verifyErrorLabel.text = ""
    }
    
    //MARK: - Assistant Methods
    
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
    
    func checkInputData() {
        
        let nameText = self.nameTextField.text ?? ""
        let phoneText = self.phoneTextField.text ?? ""
        let pwText = self.passwordTextField.text ?? ""
        let confirmPwText = self.confirmPwTextField.text ?? ""
        
        if nameText.count == 0 {
            self.nameErrorLabel.text = NSLocalizedString("Register_Input_Name_Alert_Text", comment: "")
            self.nameErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.phoneErrorLabel.text = ""
            self.pwErrorLabel.text = ""
            self.confirmPwErrorLabel.text = ""
            self.verifyErrorLabel.text = ""
            
        }else if phoneText.count == 0 {
            self.phoneErrorLabel.text = NSLocalizedString("Register_Input_Phone_Alert_Text", comment: "")
            self.phoneErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.nameErrorLabel.text = ""
            self.pwErrorLabel.text = ""
            self.confirmPwErrorLabel.text = ""
            self.verifyErrorLabel.text = ""
            
        }else if pwText.count == 0 {
            self.pwErrorLabel.text = NSLocalizedString("Register_Input_Pw_Alert_Text", comment: "")
            self.pwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.nameErrorLabel.text = ""
            self.phoneErrorLabel.text = ""
            self.confirmPwErrorLabel.text = ""
            self.verifyErrorLabel.text = ""
            
        }else if pwText.count < 8 {
            self.pwErrorLabel.text = NSLocalizedString("Register_Input_Pw_8_Alert_Text", comment: "")
            self.pwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.nameErrorLabel.text = ""
            self.phoneErrorLabel.text = ""
            self.confirmPwErrorLabel.text = ""
            self.verifyErrorLabel.text = ""
            
        }else if confirmPwText.count == 0 {
            self.confirmPwErrorLabel.text = NSLocalizedString("Register_Input_Confirm_Pw_Alert_Text", comment: "")
            self.confirmPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.nameErrorLabel.text = ""
            self.phoneErrorLabel.text = ""
            self.pwErrorLabel.text = ""
            self.verifyErrorLabel.text = ""
            
        }else if pwText != confirmPwText {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Register_Input_diff_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
            self.confirmPwErrorLabel.text = NSLocalizedString("Register_Input_diff_Alert_Text", comment: "")
            self.confirmPwErrorLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
            
            self.nameErrorLabel.text = ""
            self.phoneErrorLabel.text = ""
            self.pwErrorLabel.text = ""
            self.verifyErrorLabel.text = ""
            
        }else {
            
            self.createRegisterUserData(name: nameText, phone: phoneText, pw: pwText)
        }
        
    }
    
    
    //MARK: - Action
    
    @objc func verifyCodeBtnClick(_ sender:UIButton){
        
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
