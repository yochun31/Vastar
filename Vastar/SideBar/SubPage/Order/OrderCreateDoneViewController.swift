//
//  OrderCreateDoneViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/7/11.
//

import UIKit

class OrderCreateDoneViewController: UIViewController {
    
    
    @IBOutlet var infoTitleLabel: UILabel!
    @IBOutlet var laterPayBtn: UIButton!
    @IBOutlet var nowPayBtn: UIButton!
    
    let userDefault = UserDefaults.standard
    var orderNo:String = ""
    var totalFinalPrice:Int = 0
    
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
        
        self.infoTitleLabel.text = NSLocalizedString("Order_Create_Done_text", comment: "")
        self.infoTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.infoTitleLabel.font = UIFont(name: "PingFangTC-Semibold", size: 30.0)
        
        self.laterPayBtn.setTitle(NSLocalizedString("Order_Later_Pay_Btn_title", comment: ""), for: .normal)
        self.laterPayBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.laterPayBtn.addTarget(self, action: #selector(laterPayBtnClick(_:)), for: .touchUpInside)
        
        self.nowPayBtn.setTitle(NSLocalizedString("Order_Now_Pay_Btn_title", comment: ""), for: .normal)
        self.nowPayBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.nowPayBtn.addTarget(self, action: #selector(nowPayBtnClick(_:)), for: .touchUpInside)
    }

    
    //MARK:- Assistant Methods
    
    
    //MARK: - Action
    
    @objc func laterPayBtnClick(_ sender:UIButton) {
        
        VClient.sharedInstance().VCDeleteAllShoppingCarData { isDone in
            if isDone {
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    @objc func nowPayBtnClick(_ sender:UIButton) {
        
        VClient.sharedInstance().VCDeleteAllShoppingCarData { isDone in
            if isDone {
                self.userDefault.set(1, forKey: "backDefault")
                let vc = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
                vc.orderNo = self.orderNo
                vc.getUrl_OrderNo = self.orderNo
                vc.totalPayPrice = self.totalFinalPrice
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
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
