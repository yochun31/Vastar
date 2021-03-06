//
//  CustomAlertView.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/8/4.
//

import UIKit

protocol CustomAlertViewDelegate {
    func alertBtnClick(btnTag:Int)
}

class CustomAlertView: UIView {

    @IBOutlet var alertTitleLabel: UILabel!
    @IBOutlet var alertBtn: UIButton!
    
    var delegate:CustomAlertViewDelegate?
    
    private var titleSt:String = ""
    private var btnTitleSt:String = ""
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
    
    init(title:String,btnTitle:String,tag:Int,frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        self.titleSt = title
        self.btnTitleSt = btnTitle
        self.btnTag = tag
        setInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Interface Methods
    
    func loadXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomAlertView", bundle: bundle)
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
        
        self.alertBtn.setTitle(self.btnTitleSt, for: .normal)
        self.alertBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.alertBtn.tag = self.btnTag
        self.alertBtn.addTarget(self, action: #selector(alertBtnClick(_:)), for: .touchUpInside)

    }
    
    // Action
    
    @objc func alertBtnClick(_ sender:UIButton) {
        self.delegate?.alertBtnClick(btnTag: sender.tag)
        
    }

}
