//
//  ChangePwViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/7.
//

import UIKit

protocol ChangePwViewDelegate {
    func goVc()
}

class ChangePwViewController: UIViewController {

    @IBOutlet var oldPwTextField: UITextField!
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
    
    var delegate:ChangePwViewDelegate?
    var accountPhone:String = ""
    

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLeftBarButton()
        setInterface()
        
    }
    
    
    //MARK: - UI Interface Methods
    
    func setLeftBarButton() {
        let leftBarBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBarBtn.setImage(UIImage(named: "menu"), for: .normal)
        leftBarBtn.addTarget(revealViewController(), action: #selector(revealViewController()?.revealSideMenu), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem(customView: leftBarBtn)
        self.navigationItem.leftBarButtonItem = leftBarItem

    }
    
    func setInterface() {
        
        self.navigationItem.title = NSLocalizedString("Change_Pw_title", comment: "")
        
        self.oldPwTextField.placeholder = NSLocalizedString("Change_Pw_Old_title", comment: "")
        self.oldPwTextField.isSecureTextEntry = true
        
        self.newPwTextField.placeholder = NSLocalizedString("Change_Pw_New_title", comment: "")
        self.newPwTextField.isSecureTextEntry = true
        
        self.confirmPwTextField.placeholder = NSLocalizedString("Change_Pw_Confirm_title", comment: "")
        self.confirmPwTextField.isSecureTextEntry = true
        
        self.verifyCodeTextField.placeholder = NSLocalizedString("Change_Pw_Verify_Code_title", comment: "")
        
        self.verifyCodeBtn.setTitle(NSLocalizedString("Change_Pw_Verify_Code_Btn_title", comment: ""), for: .normal)
        self.verifyCodeBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.verifyCodeBtn.addTarget(self, action: #selector(verifyCodeBtnClick(_:)), for: .touchUpInside)
        
        self.confirmBtn.setTitle(NSLocalizedString("Change_Pw_Confirm_Btn_title", comment: ""), for: .normal)
        self.confirmBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick(_:)), for: .touchUpInside)
        
        self.cancelBtn.setTitle(NSLocalizedString("Change_Pw_Cancel_Btn_title", comment: ""), for: .normal)
        self.cancelBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
    }
    
    
    //MARK: - Assistant Methods
    
    func getUserInfo(accountName:String,oldPwSt:String,newPwSt:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        
        VClient.sharedInstance().VCGetUserInfoByPhone(phone: accountName) { (_ isSuccess:Bool,_ message:String,_ dictResData:[String:Any]) in
            
            if isSuccess {
                let res_registerTime = dictResData["RegisterTime"] as? String ?? ""
                let registerTimeArray = res_registerTime.split(separator: ".")
                self.userResgisterTime = String(registerTimeArray[0])
                
                let oldPassWord:String = "\(oldPwSt)\(self.userResgisterTime)"
                let newPassWord:String = "\(newPwSt)\(self.userResgisterTime)"
                self.updateChangePw(phone: accountName, oldPw: oldPassWord, newPw: newPassWord)

            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                    
                }
            }
        }
    }
    
    func updateChangePw(phone:String,oldPw:String,newPw:String) {
        
        VClient.sharedInstance().VCUpdateChangePw(phone: phone, oldPw: oldPw, newPw: newPw) { (_ isSuccess:Bool,_ message:String) in
            
            if isSuccess {
                print(">>\(message)<<")
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Change_Pw_Update_Success_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                    
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            }
        }
        
    }
    
    
    func checkInputData() {
        
        let oldPwText = self.oldPwTextField.text ?? ""
        let newPwText = self.newPwTextField.text ?? ""
        let confirmPwText = self.confirmPwTextField.text ?? ""
        let veriftyCodeText = self.verifyCodeTextField.text ?? ""
        
        if oldPwText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Change_Pw_Input_Old_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if newPwText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Change_Pw_Input_New_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if newPwText.count < 8 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Change_Pw_Input_Pw_8_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if confirmPwText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Change_Pw_Input_Confirm_Pw_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if confirmPwText != newPwText {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Change_Pw_Input_diff_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if veriftyCodeText.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Change_Pw_Input_VeriftyCode_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if veriftyCodeText != verifyCodeSt {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Change_Pw_VeriftyCode_Error_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else{
            
            self.getUserInfo(accountName: self.accountPhone, oldPwSt: oldPwText, newPwSt: newPwText)
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
    
    
    //MARK: - Action
    
    @objc func confirmBtnClick(_ sender:UIButton) {
        
        checkInputData()
    }
    
    @objc func cancelBtnClick(_ sender:UIButton) {
        
        let vc = SMMainViewController(nibName: "SMMainViewController", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.sideMenuTitle = self.accountPhone
        self.present(vc, animated: false, completion: nil)
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

}
