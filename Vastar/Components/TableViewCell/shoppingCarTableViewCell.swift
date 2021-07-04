//
//  shoppingCarTableViewCell.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/30.
//

import UIKit

protocol ShoppingCarTableviewDelegate {
    func amountAddBtnClick(index:Int)
    func amountLessBtnClick(index:Int)
}

class shoppingCarTableViewCell: UITableViewCell {
    
    
    @IBOutlet var productPhoto: UIImageView!
    @IBOutlet var productTitleLabel: UILabel!
    
    @IBOutlet var closeBtn: UIButton!
    
    @IBOutlet var amountTextField: UITextField!
    
    @IBOutlet var amountAddBtn: CustomButton!
    @IBOutlet var amountLessBtn: CustomButton!
    
    var delegate:ShoppingCarTableviewDelegate?
    
    private var IDArray:Array<Int> = []
    private var titleArray:Array<String> = []
    private var colorArray:Array<String> = []
    private var amountArray:Array<Int> = []
    private var vArray:Array<String> = []
    private var priceArray:Array<Int> = []
    private var photoArray:Array<UIImage> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadData(titleST:String,amount:Int,photo:UIImage) {
        
        self.productTitleLabel.text = titleST
        self.productTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.productPhoto.image = photo
        
        self.amountTextField.text = String(amount)
        self.amountTextField.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.amountAddBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        self.amountLessBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        
        self.amountAddBtn.addTarget(self, action: #selector(amountAddBtnClick(_:)), for: .touchUpInside)
        
        self.amountLessBtn.addTarget(self, action: #selector(amountLessBtnClick(_:)), for: .touchUpInside)
    }
    
    
    //MARK: - Assistant Methods
    

    
    
    
    //MARK: - Action
    
    @objc func amountAddBtnClick(_ sender:CustomButton) {
        
        print("====\(sender.tag)")
        
        var amountNum:Int = Int(self.amountTextField.text ?? "0") ?? 0
        amountNum = amountNum + 1
        self.amountTextField.text = String(amountNum)
        self.delegate?.amountAddBtnClick(index: sender.tag)
    }
    
    @objc func amountLessBtnClick(_ sender:CustomButton) {
        
        var amountNum:Int = Int(self.amountTextField.text ?? "0") ?? 0
        if amountNum > 0 {
            amountNum = amountNum - 1
            self.amountTextField.text = String(amountNum)
            self.delegate?.amountLessBtnClick(index: sender.tag)
        }
    }
}
