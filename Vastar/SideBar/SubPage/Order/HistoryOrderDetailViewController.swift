//
//  HistoryOrderDetailViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/7/16.
//

import UIKit

class HistoryOrderDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var productTableView: UITableView!
    
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
    
    @IBOutlet var viewContainer: UIView!
    
    
    private var IDArray:Array<Int> = []
    private var accountNameArray:Array<String> = []
    private var productNoArray:Array<String> = []
    private var productNameArray:Array<String> = []
    private var productVoltageArray:Array<String> = []
    private var productColorArray:Array<String> = []
    private var productPriceArray:Array<Int> = []
    private var productQuantityArray:Array<Int> = []
    private var productTotalPriceArray:Array<Int> = []
    
    private var productImagDict:[String:String] = [:]
    
    var dataDict:[String:Any] = [:]
    var orderNoSt:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
        setTableView()
        getOrderDetailData()
    }
    
    //MARK: - UI Interface Methods
    
    // 設定UI介面
    
    func setInterface() {
        
        self.navigationItem.title = NSLocalizedString("", comment: "")
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.viewContainer.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)

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
    
    func setTableView() {
        
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        
        self.productTableView.separatorStyle = .none
        
        self.productTableView.register(UINib(nibName: "CheckoutProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutProductCell")
        self.productTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
    }
    
    // MARK: - Assistant Methods

    func getOrderDetailData() {
        
        
        VClient.sharedInstance().VCGetOrderDetailByNo(orderNo: self.orderNoSt) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            
            if isSuccess {
                if resDataArray.count != 0 {
                    
                    self.IDArray = resDataArray[0] as? Array<Int> ?? []
                    self.accountNameArray = resDataArray[1] as? Array<String> ?? []
                    self.productNoArray = resDataArray[2] as? Array<String> ?? []
                    self.productNameArray = resDataArray[3] as? Array<String> ?? []
                    self.productVoltageArray = resDataArray[4] as? Array<String> ?? []
                    self.productColorArray = resDataArray[5] as? Array<String> ?? []
                    self.productPriceArray = resDataArray[6] as? Array<Int> ?? []
                    self.productQuantityArray = resDataArray[7] as? Array<Int> ?? []
                    self.productTotalPriceArray = resDataArray[8] as? Array<Int> ?? []
                    self.getProductImageUrl()
                }
            }
        }
    }
    
    func getProductImageUrl() {
        
        VClient.sharedInstance().VCGetProductImagUrlByNo(productNoArray: self.productNoArray) { (_ isSuccess:Bool,_ message:String,_ resDataDict:[String:String]) in

            if isSuccess {

                self.productImagDict = resDataDict
                self.productTableView.reloadData()
                print("===> \(resDataDict)")
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
    
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.productNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CheckoutProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CheckoutProductCell", for: indexPath) as! CheckoutProductTableViewCell
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let selectBkView = UIView()
        selectBkView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBkView

        let NO:String = self.productNoArray[indexPath.row]
        let name:String = self.productNameArray[indexPath.row]
        let voltage:String = self.productVoltageArray[indexPath.row]
        let color:String = self.productColorArray[indexPath.row]
        let price:Int = self.productPriceArray[indexPath.row]
        let quantity:Int = self.productQuantityArray[indexPath.row]

    
        let urlString:String = self.productImagDict[NO] ?? ""
        let url = URL.init(string: urlString)
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let countPriceSt:String = format.string(from: NSNumber(value:price)) ?? ""
  
        let titleSt:String = "\(name)\(voltage),\(color)\n共\(quantity)件\n單價:\(countPriceSt)"

        cell.loadData(titleSt: titleSt, url: url!)

        return cell
    }

}
