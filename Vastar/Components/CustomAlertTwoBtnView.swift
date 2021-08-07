//
//  CustomAlertTwoBtnView.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/8/7.
//

import UIKit

protocol CustomAlertTwoBtnViewDelegate {
    func alertBtn1Click(btnTag:Int)
    func alertBtn2Click(btnTag:Int)
}

class CustomAlertTwoBtnView: UIView {
    
    
    @IBOutlet var alertTitleLabel: UILabel!
    
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    
    var delegate:CustomAlertTwoBtnViewDelegate?
    
    private var titleSt:String = ""
    private var btn1TitleSt:String = ""
    private var btn2TitleSt:String = ""
    private var btnTag:Int = 0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title:String,btn1Title:String,btn2Title:String,tag:Int,frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        self.titleSt = title
        self.btn1TitleSt = btn1Title
        self.btn2TitleSt = btn2Title
        self.btnTag = tag
        setInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Interface Methods
    
    func loadXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomAlertTwoBtnView", bundle: bundle)
        ///透過nib來取得xibView
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(xibView)
        
        ///設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    // 設定UI介面
    
    func setInterface() {
        
        self.alertTitleLabel.text = self.titleSt
        self.alertTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.btn1.setTitle(self.btn1TitleSt, for: .normal)
        self.btn1.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.btn1.tag = self.btnTag
        self.btn1.addTarget(self, action: #selector(btn1Click(_:)), for: .touchUpInside)
        
        self.btn2.setTitle(self.btn2TitleSt, for: .normal)
        self.btn2.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.btn2.tag = self.btnTag
        self.btn2.addTarget(self, action: #selector(btn2Click(_:)), for: .touchUpInside)

    }
    
    //MARK: - Action
    
    @objc func btn1Click(_ sender:UIButton) {
        self.delegate?.alertBtn1Click(btnTag: sender.tag)
    }
    
    @objc func btn2Click(_ sender:UIButton) {
        self.delegate?.alertBtn2Click(btnTag: sender.tag)
    }

}
