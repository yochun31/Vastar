//
//  ConnectionViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2022/5/5.
//

import UIKit

class ConnectionViewController: UIViewController {

    @IBOutlet var lineBtn: UIButton!
    @IBOutlet var wechatBtn: UIButton!
    
    @IBOutlet var lineIdTitleLabel: UILabel!
    @IBOutlet var wechatIdTitleLabel: UILabel!
    @IBOutlet var phoneTitleLabel: UILabel!
    @IBOutlet var addressTitleLabel: UILabel!
    
    @IBOutlet var lineIdLabel: UILabel!
    @IBOutlet var wechatIdLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setInterface()
    }
    
    //MARK: - UI Interface Methods
    
    // 設定UI介面
    
    func setInterface() {
        
        self.navigationItem.title = NSLocalizedString("Connection_title", comment: "")
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let textColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 20.0)
        
        
        self.lineIdTitleLabel.text = NSLocalizedString("Connection_Info_Line_title", comment: "")
        self.lineIdTitleLabel.textColor = textColor
        self.lineIdLabel.text = NSLocalizedString("Connection_Info_Line_Text", comment: "")
        self.lineIdLabel.textColor = textColor
        
        self.wechatIdTitleLabel.text = NSLocalizedString("Connection_Info_Wechat_title", comment: "")
        self.wechatIdTitleLabel.textColor = textColor
        self.wechatIdLabel.text = NSLocalizedString("Connection_Info_Wechat_Text", comment: "")
        self.wechatIdLabel.textColor = textColor
        
        self.phoneTitleLabel.text = NSLocalizedString("Connection_Info_Phone_title", comment: "")
        self.phoneTitleLabel.textColor = textColor
        self.phoneLabel.text = NSLocalizedString("Connection_Info_Phone_Text", comment: "")
        self.phoneLabel.textColor = textColor
        
        self.addressTitleLabel.text = NSLocalizedString("Connection_Info_Address_title", comment: "")
        self.addressTitleLabel.textColor = textColor
        self.addressLabel.text = NSLocalizedString("Connection_Info_Address_Text", comment: "")
        self.addressLabel.textColor = textColor
        
        self.lineBtn.addTarget(self, action: #selector(lineBtnClick(_:)), for: .touchUpInside)
        self.wechatBtn.addTarget(self, action: #selector(wechatBtnClick(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(leftbackBtnClick(_:)))
    }

    
    // MARK: - Action
    
    @objc func lineBtnClick(_ sender:UIButton) {
        
        let lineUrl = URL(string: "https://line.me/R/ti/p/3VhRpkViZ_")
        
        if UIApplication.shared.canOpenURL(lineUrl!) {
            
            UIApplication.shared.open(lineUrl!, options: [:], completionHandler: nil)
        }
    }
    
    @objc func wechatBtnClick(_ sender:UIButton) {
        
        let wechatUrl = URL(string: "weixin://")
        
        if UIApplication.shared.canOpenURL(wechatUrl!) {

            UIApplication.shared.open(wechatUrl!, options: [:], completionHandler: nil)
        }
    }
    
    @objc func leftbackBtnClick(_ sender:UIButton) {
        
        self.navigationController?.popViewController(animated: true)
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
