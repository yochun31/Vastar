//
//  LoginViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/5/31.
//

import UIKit


class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var accountNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var forgetPwBtn: UIButton!
    @IBOutlet var registerBtn: UIButton!
    
    private var userResgisterTime:String = ""
    
    private var vaiv = VActivityIndicatorView()
    
    //MARK: -  Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.accountNameTextField.text = ""
        self.passwordTextField.text = ""
    }

    // MARK: - UI Interface Methods
    
    func setInterface() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let placeHolderTextColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let textColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let lineColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 20.0)
        
        self.accountNameTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.accountNameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Login_Account_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.accountNameTextField.setTextColor(textColor, font: font)
        
        self.passwordTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.passwordTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Login_Password_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.passwordTextField.setTextColor(textColor, font: font)
        
//        self.passwordTextField.placeholder = NSLocalizedString("Login_Password_title", comment: "")
        self.passwordTextField.isSecureTextEntry = true
        
        self.loginBtn.setTitle(NSLocalizedString("Login_Button_title", comment: ""), for: .normal)
        self.loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25.0)
        self.loginBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.loginBtn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
        
        self.forgetPwBtn.setTitle(NSLocalizedString("Login_Forget_Button_title", comment: ""), for: .normal)
        self.forgetPwBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.forgetPwBtn.addTarget(self, action: #selector(forgetPwBtn(_:)), for: .touchUpInside)
        
        self.registerBtn.setTitle(NSLocalizedString("Login_Register_Button_title", comment: ""), for: .normal)
        self.registerBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.registerBtn.addTarget(self, action: #selector(registerBtn(_:)), for: .touchUpInside)
        
    }
    
    //MARK: - Assistant Methods
    
    func getUserInfo(accountName:String,pw:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Login_ActivityIndicatorView_title", comment: ""))
        
        VClient.sharedInstance().VCGetUserInfoByPhone(phone: accountName) { (_ isSuccess:Bool,_ message:String,_ dictResData:[String:Any]) in
            
            if isSuccess {
                let res_registerTime = dictResData["RegisterTime"] as? String ?? ""
                let registerTimeArray = res_registerTime.split(separator: ".")
                self.userResgisterTime = String(registerTimeArray[0])
                
                let passWord:String = "\(pw)\(self.userResgisterTime)"
                self.loginVerification(accountName: accountName, pw: passWord)
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                    
                }
            }
        }
    }
    
    func loginVerification(accountName:String,pw:String) {
        
        VClient.sharedInstance().VCLoginByPhone(account: accountName, pw: pw) { (_ isSuccess:Bool,_ message:String) in
            
            if isSuccess {
                
                print("--\(message)--")

                self.vaiv.stopProgressHUD(view: self.view)
                let frontNavigationController:UINavigationController

                let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
                frontNavigationController = UINavigationController(rootViewController: vc)
                let sideMenuTable = SMSideMenuViewController(nibName: "SMSideMenuViewController", bundle: nil)
                sideMenuTable.menuTitle = accountName
                
                let reveal = SWRevealViewController(rearViewController: sideMenuTable, frontViewController: frontNavigationController)
                reveal?.modalPresentationStyle = .fullScreen
                self.present(reveal!, animated: true, completion:  nil)
                
                
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                    
                }
            }
        }
    }
    
    
    
    //MARK: - Action
    
    @objc func loginBtnClick(_ sender:UIButton) {
        
        let accountText:String = self.accountNameTextField.text ?? ""
        let pwText:String = self.passwordTextField.text ?? ""
        
        if accountText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Login_Input_Phone_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                
            }
        }else if pwText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Login_Input_Pw_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                
            }
        }else {
            getUserInfo(accountName: accountText, pw: pwText)
        }
        
        
        
    }
    
    @objc func forgetPwBtn(_ sender:UIButton) {
        
        let vc = ForgetPwViewController(nibName: "ForgetPwViewController", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func registerBtn(_ sender:UIButton) {
        
        let vc = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
