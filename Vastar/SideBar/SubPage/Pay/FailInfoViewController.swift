//
//  FailInfoViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/9/9.
//

import UIKit

class FailInfoViewController: UIViewController {

    @IBOutlet var infoTitleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var confirmBtn: UIButton!
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - UI Interface Methods
    
    // 設定UI介面
    
    func setInterface() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        self.infoTitleLabel.text = NSLocalizedString("Pay_Fail_Title", comment: "")
        self.infoTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.infoTitleLabel.font = UIFont(name: "PingFangTC-Semibold", size: 30.0)
        
        self.infoLabel.text = NSLocalizedString("Pay_Fail_Info_Text", comment: "")
        self.infoLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.infoLabel.font = UIFont(name: "PingFangTC-Semibold", size: 18.0)
        
        self.confirmBtn.setTitle(NSLocalizedString("Alert_Sure_title", comment: ""), for: .normal)
        self.confirmBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick(_:)), for: .touchUpInside)
        
    }

    
    //MARK:- Assistant Methods
    
    

    //MARK: - Action
    
    @objc func confirmBtnClick(_ sender:UIButton) {
        
        self.navigationController?.popToRootViewController(animated: false)
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
