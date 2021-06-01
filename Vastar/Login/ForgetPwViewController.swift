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
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
    }

    
    //MARK: - UI Interface Methods
    
    func setInterface() {
        
        self.phoneTextField.placeholder = NSLocalizedString("Forget_Pw_Phone_title", comment: "")
        
        self.newPwTextField.placeholder = NSLocalizedString("Forget_Pw_New_title", comment: "")
        
        self.confirmPwTextField.placeholder = NSLocalizedString("Forget_Pw_Confirm_title", comment: "")
        
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
    
    
    //MARK: - Action
    
    @objc func verifyCodeBtnClick(_ sender:UIButton) {
        
    }
    
    @objc func confirmBtnClick(_ sender:UIButton) {
        
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
