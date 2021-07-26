//
//  HistoryOrderDetailViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/7/16.
//

import UIKit

class HistoryOrderDetailViewController: UIViewController {
    
    
    @IBOutlet var payTitleLabel: UILabel!
    @IBOutlet var payValueLabel: UILabel!
    
    @IBOutlet var transportTitleLabel: UILabel!
    @IBOutlet var transportValueLabel: UILabel!
    
    @IBOutlet var addressTitleLabel: UILabel!
    
    @IBOutlet var receiverNameLabel: UILabel!
    @IBOutlet var receiverPhoneLabel: UILabel!
    @IBOutlet var receiverAddressLabel: UILabel!
    
    @IBOutlet var returnInfoTitleLabel: UILabel!
    @IBOutlet var returnInfoValueLabel: UILabel!
    
    @IBOutlet var orderTitleLabel: UILabel!
    
    @IBOutlet var totalProductTitleLabel: UILabel!
    @IBOutlet var totalProductValueLabel: UILabel!
    
    @IBOutlet var feeTitleLabel: UILabel!
    @IBOutlet var feeValueLabel: UILabel!
    
    @IBOutlet var totalPriceTitleLabel: UILabel!
    @IBOutlet var totalPriceValueLabel: UILabel!
    
    var dataDict:[String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
    }
    
    //MARK: - UI Interface Methods
    
    func setInterface() {
        
        self.navigationItem.title = NSLocalizedString("", comment: "")
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)

        let format = NumberFormatter()
        format.numberStyle = .decimal
        
        self.payTitleLabel.text = NSLocalizedString("Shopping_Checkout_Pay_title", comment: "")
        self.payTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.payTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.payValueLabel.text = dataDict["PaymentMethod"] as? String ?? ""
        self.payValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.transportTitleLabel.text = NSLocalizedString("Shopping_Checkout_Transport_title", comment: "")
        self.transportTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.transportTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.transportValueLabel.text = dataDict["ShippingMethod"] as? String ?? ""
        self.transportValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.addressTitleLabel.text = NSLocalizedString("Shopping_Checkout_Address_title", comment: "")
        self.addressTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.addressTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.receiverNameLabel.text = dataDict["Receiver_Name"] as? String ?? ""
        self.receiverNameLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.receiverPhoneLabel.text = dataDict["Receiver_Phone"] as? String ?? ""
        self.receiverPhoneLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        let city:String = dataDict["Receiver_City"] as? String ?? ""
        let town:String = dataDict["Receiver_District"] as? String ?? ""
        let code:String = dataDict["Receiver_CityCode"] as? String ?? ""
        let addres:String = dataDict["Receiver_Address"] as? String ?? ""
        let addresSt:String = "\(addres),\(town),\(city),\(code)"
        self.receiverAddressLabel.text = addresSt
        self.receiverAddressLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.returnInfoTitleLabel.text = NSLocalizedString("Shopping_Checkout_ReturnInfo_title", comment: "")
        self.returnInfoTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.returnInfoValueLabel.text = NSLocalizedString("Shopping_Checkout_ReturnInfo_Text", comment: "")
        self.returnInfoValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.orderTitleLabel.text = NSLocalizedString("Shopping_Checkout_Order_title", comment: "")
        self.orderTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.orderTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.totalProductTitleLabel.text = NSLocalizedString("Shopping_Checkout_Total_title", comment: "")
        self.totalProductTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        let totalProduct = dataDict["TotalProductPrice"] as? Int ?? 0
        let totalProductSt:String = format.string(from: NSNumber(value:totalProduct)) ?? ""
        self.totalProductValueLabel.text = "$\(totalProductSt)"
        self.totalProductValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.feeTitleLabel.text = NSLocalizedString("Shopping_Checkout_Fee_title", comment: "")
        self.feeTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        let fee = dataDict["ShippingFee"] as? Int ?? 0
        let feeSt:String = format.string(from: NSNumber(value:fee)) ?? ""
        self.feeValueLabel.text = "$\(feeSt)"
        self.feeValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.totalPriceTitleLabel.text = NSLocalizedString("Shopping_Checkout_Money_title", comment: "")
        self.totalPriceTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.totalPriceTitleLabel.font = UIFont(name: "PingFangTC-Semibold", size: 17.0)
        
        let totalPrice = dataDict["TotalPrice"] as? Int ?? 0
        let totalPriceSt:String = format.string(from: NSNumber(value:totalPrice)) ?? ""
        self.totalPriceValueLabel.text = "$\(totalPriceSt)"
        self.totalPriceValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.totalPriceValueLabel.font = UIFont(name: "PingFangTC-Semibold", size: 17.0)
        
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
