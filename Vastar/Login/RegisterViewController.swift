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
        
        self.confirmPwTextField.placeholder = NSLocalizedString("Register_Confirm_Password_title", comment: "")
        
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
    }
    
    //MARK: - Action
    
    @objc func verifyCodeBtnClick(_ sender:UIButton){
        
    }
    
    @objc func registerBtnClick(_ sender:UIButton){
        
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
