//
//  DeleteUserViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2024/4/17.
//

import UIKit

class DeleteUserViewController: UIViewController,CustomAlertViewDelegate,CustomAlertTwoBtnViewDelegate {
    
    private var cav = CustomAlertView()
    private var cavt = CustomAlertTwoBtnView()
    
    var accountSt:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setLeftBarButton()
        setupSWReveal()
        setInterface()
        checkDeleteUser()
    }
    
    //MARK: - UI Interface Methods
    
    // 設定Navigation左側按鈕
    
    func setLeftBarButton() {
        let leftBarBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBarBtn.setImage(UIImage(named: "menu"), for: .normal)
        leftBarBtn.addTarget(self, action: #selector(leftBarBtnClick(_:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem(customView: leftBarBtn)
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func setupSWReveal(){
        //adding panGesture to reveal menu controller
        view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        //adding tap gesture to hide menu controller
        view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        //setting reveal width of menu controller manually
        self.revealViewController()?.rearViewRevealWidth = UIScreen.main.bounds.width * (2/3)
    }
    
    // 設定UI介面
    
    func setInterface() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        self.navigationItem.title = NSLocalizedString("Member_title", comment: "")
        
    }
    
    //MARK: - Assistant Methods
    
    func checkDeleteUser() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHight = screenSize.height
        
        self.cavt = CustomAlertTwoBtnView(title: NSLocalizedString("Member_Recipient_Delete_Alert_Text", comment: ""), btn1Title: NSLocalizedString("Member_Confirm_Btn_title", comment: ""), btn2Title: NSLocalizedString("Alert_Cancel_title", comment: ""), tag: 1, frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHight))
        self.cavt.delegate = self
        self.view.addSubview(self.cavt)
    }
    
    func deleteUser() {
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowTime:String = dateFormatter.string(from: now)
        
        VClient.sharedInstance().VCDeleteUserByPhone(phone: accountSt, delTime: nowTime) { isSuccess, message, isResult in
            if isSuccess {
                
                if isResult == -1 {
                    self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 1, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    self.cav.delegate = self
                    self.view.addSubview(self.cav)
                }else{
                    self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 2, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    self.cav.delegate = self
                    self.view.addSubview(self.cav)
                }
                
                
            }
        }
    }
    
    
    //MARK: - Action
    
    @objc func leftBarBtnClick(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - CustomAlertViewDelegate
    
    func alertBtnClick(btnTag: Int) {
        
        if btnTag == 1 {
            self.cav.removeFromSuperview()
            
            let nav = UINavigationController()
            let reveal = self.revealViewController()
            let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
            nav.viewControllers = [vc]
            reveal?.pushFrontViewController(nav, animated: true)
        }else{
            self.cav.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - CustomAlertTwoBtnViewDelegate
    
    func alertBtn1Click(btnTag: Int) {
        
        if btnTag == 1 {
            self.cavt.removeFromSuperview()
            self.deleteUser()
        }
    }
    
    func alertBtn2Click(btnTag: Int) {
        if btnTag == 1 {
            self.cavt.removeFromSuperview()
            
            let nav = UINavigationController()
            let reveal = self.revealViewController()
            let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
            nav.viewControllers = [vc]
            reveal?.pushFrontViewController(nav, animated: true)
        }
    }

}
