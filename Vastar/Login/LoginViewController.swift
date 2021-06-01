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
    
    
    //MARK: - Action
    
    @objc func loginBtnClick(_ sender:UIButton) {
        
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
