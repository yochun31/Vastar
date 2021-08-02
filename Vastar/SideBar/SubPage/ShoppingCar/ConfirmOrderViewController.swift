//
//  ConfirmOrderViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/7/8.
//

import UIKit

class ConfirmOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
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
    
    @IBOutlet var sendBtn: UIButton!
    
    @IBOutlet var contentView: UIView!
    
    private var IDArray:Array<Int> = []
    private var NoArray:Array<String> = []
    private var titleArray:Array<String> = []
    private var colorArray:Array<String> = []
    private var amountArray:Array<Int> = []
    private var vArray:Array<String> = []
    private var priceArray:Array<Int> = []
    private var photoArray:Array<UIImage> = []
    
    private var receiverIDArray:Array<Int> = []
    private var receiverNameArray:Array<String> = []
    private var receiverPhoneArray:Array<String> = []
    private var receiverCityArray:Array<String> = []
    private var receiverDistrictArray:Array<String> = []
    private var receiverAddressArray:Array<String> = []
    
    let userDefault = UserDefaults.standard
    var dataDict:[String:Any] = [:]
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
        setTableView()
        getCheckoutData()
    }
    
    
    //MARK: - UI Interface Methods
    
    // 設定UI介面
    
    func setInterface() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.contentView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
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
        
        self.sendBtn.setTitle(NSLocalizedString("Shopping_Checkout_Send_Btn_title", comment: ""), for: .normal)
        self.sendBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.sendBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: .touchUpInside)
        
    }
    
    func setTableView() {
        
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        self.productTableView.register(UINib(nibName: "CheckoutProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutProductCell")
        self.productTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    
    //MARK:- Assistant Methods
    
    // 取得結帳資料
    
    func getCheckoutData() {
        
        self.IDArray.removeAll()
        self.NoArray.removeAll()
        self.titleArray.removeAll()
        self.colorArray.removeAll()
        self.amountArray.removeAll()
        self.vArray.removeAll()
        self.priceArray.removeAll()
        self.photoArray.removeAll()
        
        VClient.sharedInstance().VCGetShoppingCarData { (_ dataArray:Array<Array<Any>>,_ isDone:Bool) in
            if isDone {
                if dataArray.count != 0 {
                    
                    self.IDArray = dataArray[0] as? Array<Int> ?? []
                    self.NoArray = dataArray[1] as? Array<String> ?? []
                    self.titleArray = dataArray[2] as? Array<String> ?? []
                    self.colorArray = dataArray[3] as? Array<String> ?? []
                    self.amountArray = dataArray[4] as? Array<Int> ?? []
                    self.vArray = dataArray[5] as? Array<String> ?? []
                    self.priceArray = dataArray[6] as? Array<Int> ?? []
                    self.photoArray = dataArray[7] as? Array<UIImage> ?? []
                    self.productTableView.reloadData()
                }
            }
        }
    }
    
    // 新增訂單
    
    func AddOrder() {
        
        VClient.sharedInstance().VCAddOrderByData(reqBodyDict: self.dataDict) { (_ isSuccess:Bool,_ message:String,_ orderNo:String) in
            
            if isSuccess {
                
                print("--\(orderNo)")
                let vc = OrderCreateDoneViewController(nibName: "OrderCreateDoneViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    
    //MARK: - Action
    
    @objc func sendBtnClick(_ sender:UIButton) {
        
        self.userDefault.set(1, forKey: "backDefault")
        self.AddOrder()
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
        
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CheckoutProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CheckoutProductCell", for: indexPath) as! CheckoutProductTableViewCell
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let selectBkView = UIView()
        selectBkView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBkView

        let name:String = self.titleArray[indexPath.row]
        let color:String = self.colorArray[indexPath.row]
        let v:String = self.vArray[indexPath.row]
        let price:Int = self.priceArray[indexPath.row]
        let amount:Int = self.amountArray[indexPath.row]
        
        let photo:UIImage = self.photoArray[indexPath.row]
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let countPriceSt:String = format.string(from: NSNumber(value:price)) ?? ""
  
        let titleSt:String = "\(name)\n\(v),\(color)\n共\(amount)件\n$\(countPriceSt)"
        cell.loadData(titleST: titleSt, photo: photo)

        return cell
    }

}
