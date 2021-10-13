//
//  VideoTypeViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/9/28.
//

import UIKit

class VideoTypeViewController: UIViewController {

    @IBOutlet var item1Btn: UIButton!
    @IBOutlet var item2Btn: UIButton!
    @IBOutlet var item3Btn: UIButton!
    @IBOutlet var infoValueLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
    }

    
    //MARK: - UI Interface Methods
    
    // 設定UI介面
    
    func setInterface() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        self.item1Btn.setTitle(NSLocalizedString("Video_Type_Item1_Btn_title", comment: ""), for: .normal)
        self.item1Btn.addTarget(self, action: #selector(item1BtnClick(_:)), for: .touchUpInside)
        self.item1Btn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.item1Btn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        
        self.item2Btn.setTitle(NSLocalizedString("Video_Type_Item2_Btn_title", comment: ""), for: .normal)
        self.item2Btn.addTarget(self, action: #selector(item2BtnClick(_:)), for: .touchUpInside)
        self.item2Btn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.item2Btn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        
        self.item3Btn.setTitle(NSLocalizedString("Video_Type_Item3_Btn_title", comment: ""), for: .normal)
        self.item3Btn.addTarget(self, action: #selector(item3BtnClick(_:)), for: .touchUpInside)
        self.item3Btn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.item3Btn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        
        self.infoValueLabel.text = NSLocalizedString("Login_Info_Text", comment: "")
        self.infoValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    }
    
    // MARK: - Action
    
    @objc func item1BtnClick(_ sender:UIButton) {
        
        let vc = VideoListByTypeViewController(nibName: "VideoListByTypeViewController", bundle: nil)
        vc.typeSt = NSLocalizedString("Video_Type_Item1_Btn_Value", comment: "")
        vc.titleSt = NSLocalizedString("Video_Type_Item1_Btn_title", comment: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func item2BtnClick(_ sender:UIButton) {
        
        let vc = VideoListByTypeViewController(nibName: "VideoListByTypeViewController", bundle: nil)
        vc.typeSt = NSLocalizedString("Video_Type_Item2_Btn_Value", comment: "")
        vc.titleSt = NSLocalizedString("Video_Type_Item2_Btn_title", comment: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func item3BtnClick(_ sender:UIButton) {
        
        let vc = VideoListByTypeViewController(nibName: "VideoListByTypeViewController", bundle: nil)
        vc.typeSt = NSLocalizedString("Video_Type_Item3_Btn_Value", comment: "")
        vc.titleSt = NSLocalizedString("Video_Type_Item3_Btn_title", comment: "")
        self.navigationController?.pushViewController(vc, animated: true)
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
