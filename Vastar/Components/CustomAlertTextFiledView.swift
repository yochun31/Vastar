//
//  CustomAlertTextFiledView.swift
//  Vastar
//
//  Created by Charles Kuo on 2025/6/16.
//

import UIKit

protocol CustomAlertTextFiledViewDelegate {
    func alertTextFiledBtn1Click(btnTag:Int,inputText:String)
    func alertTextFiledBtn2Click(btnTag:Int)
}

class CustomAlertTextFiledView: UIView {
    
    
    @IBOutlet var alertTitleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    
    var delegate:CustomAlertTextFiledViewDelegate?
    
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
    
    init(title:String,btn1Title:String,btn2Title:String,tag:Int,frame: CGRect,isSecureTextEntry:Bool) {
        super.init(frame: frame)
        loadXib()
        self.titleSt = title
        self.btn1TitleSt = btn1Title
        self.btn2TitleSt = btn2Title
        self.btnTag = tag
        self.inputTextField.isSecureTextEntry = isSecureTextEntry
        setInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Interface Methods
    
    func loadXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomAlertTextFiledView", bundle: bundle)
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
        
        let bkColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let textColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let lineColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 17.0)
        self.inputTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: bkColor)
        self.inputTextField.setTextColor(textColor, font: font)

    }
    
    //MARK: - Action
    
    @objc func btn1Click(_ sender:UIButton) {
        self.delegate?.alertTextFiledBtn1Click(btnTag: sender.tag, inputText: self.inputTextField.text ?? "")
    }
    
    @objc func btn2Click(_ sender:UIButton) {
        self.delegate?.alertTextFiledBtn2Click(btnTag: sender.tag)
    }

}
