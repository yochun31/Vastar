//
//  LoginViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/5/31.
//

import UIKit


class LoginViewController: UIViewController {

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

    // MARK: - UI Interface Methods
    
    func setInterface() {
        
        self.accountNameTextField.placeholder = NSLocalizedString("Login_Account_title", comment: "")
        
        self.passwordTextField.placeholder = NSLocalizedString("Login_Password_title", comment: "")
        self.passwordTextField.isSecureTextEntry = true
        
        self.loginBtn.setTitle(NSLocalizedString("Login_Button_title", comment: ""), for: .normal)
        self.loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 25.0)
        self.loginBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.loginBtn.addTarget(self, action: #selector(loginBtnClick(_:)), for: .touchUpInside)
        
        self.forgetPwBtn.setTitle(NSLocalizedString("Login_Forget_Button_title", comment: ""), for: .normal)
        self.forgetPwBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.forgetPwBtn.addTarget(self, action: #selector(forgetPwBtn(_:)), for: .touchUpInside)
        
        self.registerBtn.setTitle(NSLocalizedString("Login_Register_Button_title", comment: ""), for: .normal)
        self.registerBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
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
                let vc = SMMainViewController(nibName: "SMMainViewController", bundle: nil)
                vc.modalPresentationStyle = .fullScreen
                vc.sideMenuTitle = accountName
                self.present(vc, animated: true, completion: nil)
                
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
