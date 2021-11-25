//
//  OrderListViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/7/9.
//

import UIKit
import CryptoSwift
import SwiftyRSA

class OrderListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CustomAlertViewDelegate {

    
    @IBOutlet var orderTableView: UITableView!
    
    
    private var orderIDArray:Array<Int> = []
    private var orderNoArray:Array<String> = []
    private var orderAccountNameArray:Array<String> = []
    private var orderTotalProductPriceArray:Array<Int> = []
    private var orderFeeArray:Array<Int> = []
    private var orderTotalPriceArray:Array<Int> = []
    private var orderReceiverNameArray:Array<String> = []
    private var orderReceiverPhoneArray:Array<String> = []
    private var orderReceiverCityArray:Array<String> = []
    private var orderReceiverTownArray:Array<String> = []
    private var orderReceiverCityCodeArray:Array<String> = []
    private var orderReceiverAddressArray:Array<String> = []
    private var orderShippingMethodArray:Array<String> = []
    private var orderPaymentMethodArray:Array<String> = []
    private var orderCreateTimeArray:Array<String> = []
    private var orderStatusArray:Array<String> = []
    private var deliveryTimeArray:Array<String> = []
    private var packageDeliveryCodeArray:Array<String> = []
    private var packageDeliveryUrlArray:Array<String> = []
    private var orderCompleteTimeArray:Array<String> = []
    
    private var cav = CustomAlertView()
    private var selectOrderNoStr:String = ""
    private var selectTotalPrice:Int = 0
    var accountPhone:String = ""
    let userDefault = UserDefaults.standard
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLeftBarButton()
        setInterface()
        setupSWReveal()
        setTableView()
        getOrderListData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let flag:Int = self.userDefault.object(forKey: "backDefault")as? Int ?? 0
        if flag == 1 {
            self.userDefault.set(0, forKey: "backDefault")
            let nav = UINavigationController()
            let reveal = self.revealViewController()
            let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
            vc.accountPhone = accountPhone
            nav.viewControllers = [vc]
            reveal?.pushFrontViewController(nav, animated: true)
        }
    }

    
    
    //MARK: - UI Interface Methods
    
    // 設定Navigation左側按鈕
    
    func setLeftBarButton() {
        let leftBarBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBarBtn.setImage(UIImage(named: "menu"), for: .normal)
        leftBarBtn.addTarget(self, action: #selector(leftBarBtnClick(_:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem(customView: leftBarBtn)
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    // 設定UI介面
    
    func setInterface() {
        self.navigationItem.title = NSLocalizedString("Order_title", comment: "")
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    func setupSWReveal(){
        //adding panGesture to reveal menu controller
        view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        //adding tap gesture to hide menu controller
        view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        //setting reveal width of menu controller manually
        self.revealViewController()?.rearViewRevealWidth = UIScreen.main.bounds.width * (2/3)
    }
    
    func setTableView() {
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
        self.orderTableView.separatorStyle = .none
        self.orderTableView.register(UINib(nibName: "OrderListTableViewCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
        self.orderTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    
    //MARK:- Assistant Methods
    
    // 取得訂單資料
    
    func getOrderListData() {
        
        self.orderIDArray.removeAll()
        self.orderNoArray.removeAll()
        self.orderAccountNameArray.removeAll()
        self.orderTotalProductPriceArray.removeAll()
        self.orderFeeArray.removeAll()
        self.orderTotalPriceArray.removeAll()
        self.orderReceiverNameArray.removeAll()
        self.orderReceiverPhoneArray.removeAll()
        self.orderReceiverCityArray.removeAll()
        self.orderReceiverTownArray.removeAll()
        self.orderReceiverCityCodeArray.removeAll()
        self.orderReceiverAddressArray.removeAll()
        self.orderShippingMethodArray.removeAll()
        self.orderPaymentMethodArray.removeAll()
        self.orderCreateTimeArray.removeAll()
        self.orderStatusArray.removeAll()
        self.deliveryTimeArray.removeAll()
        self.packageDeliveryCodeArray.removeAll()
        self.packageDeliveryUrlArray.removeAll()
        self.orderCompleteTimeArray.removeAll()
        
        VClient.sharedInstance().VCGetOrderListData(phone: self.accountPhone) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            
            if isSuccess {
                if resDataArray.count != 0 {
                    
                    self.orderIDArray = resDataArray[0] as? Array<Int> ?? []
                    self.orderNoArray = resDataArray[1] as? Array<String> ?? []
                    self.orderAccountNameArray = resDataArray[2] as? Array<String> ?? []
                    self.orderTotalProductPriceArray = resDataArray[3] as? Array<Int> ?? []
                    self.orderFeeArray = resDataArray[4] as? Array<Int> ?? []
                    self.orderTotalPriceArray = resDataArray[5] as? Array<Int> ?? []
                    self.orderReceiverNameArray = resDataArray[6] as? Array<String> ?? []
                    self.orderReceiverPhoneArray = resDataArray[7] as? Array<String> ?? []
                    self.orderReceiverCityArray = resDataArray[8] as? Array<String> ?? []
                    self.orderReceiverTownArray = resDataArray[9] as? Array<String> ?? []
                    self.orderReceiverCityCodeArray = resDataArray[10] as? Array<String> ?? []
                    self.orderReceiverAddressArray = resDataArray[11] as? Array<String> ?? []
                    self.orderShippingMethodArray = resDataArray[12] as? Array<String> ?? []
                    self.orderPaymentMethodArray = resDataArray[13] as? Array<String> ?? []
                    self.orderCreateTimeArray = resDataArray[14] as? Array<String> ?? []
                    self.orderStatusArray = resDataArray[15] as? Array<String> ?? []
                    self.deliveryTimeArray = resDataArray[16] as? Array<String> ?? []
                    self.packageDeliveryCodeArray = resDataArray[17] as? Array<String> ?? []
                    self.packageDeliveryUrlArray = resDataArray[18] as? Array<String> ?? []
                    self.orderCompleteTimeArray = resDataArray[19] as? Array<String> ?? []
                    
                    self.orderTableView.reloadData()
                }
            }
        }
    }
    
    // 建立取得的結帳資料 Dict
    
    func getCheckoutDictData(selectIndex:Int) -> [String:Any] {
        var dictData:[String:Any] = [:]
        
        let pay:String = self.orderPaymentMethodArray[selectIndex]
        let transport:String = self.orderShippingMethodArray[selectIndex]
        let name:String = self.orderReceiverNameArray[selectIndex]
        let phone:String = self.orderReceiverPhoneArray[selectIndex]
        let city:String = self.orderReceiverCityArray[selectIndex]
        let town:String = self.orderReceiverTownArray[selectIndex]
        let postalCode:String = self.orderReceiverCityCodeArray[selectIndex]
        let address:String = self.orderReceiverAddressArray[selectIndex]
        let totalProduct:Int = self.orderTotalProductPriceArray[selectIndex]
        let fee:Int = self.orderFeeArray[selectIndex]
        let total:Int = self.orderTotalPriceArray[selectIndex]
        
        dictData.updateValue(totalProduct, forKey: "TotalProductPrice")
        dictData.updateValue(fee, forKey: "ShippingFee")
        dictData.updateValue(total, forKey: "TotalPrice")
        dictData.updateValue(name, forKey: "Receiver_Name")
        dictData.updateValue(phone, forKey: "Receiver_Phone")
        dictData.updateValue(city, forKey: "Receiver_City")
        dictData.updateValue(town, forKey: "Receiver_District")
        dictData.updateValue(postalCode, forKey: "Receiver_CityCode")
        dictData.updateValue(address, forKey: "Receiver_Address")
        dictData.updateValue(transport, forKey: "ShippingMethod")
        dictData.updateValue(pay, forKey: "PaymentMethod")
        
        return dictData
    }
    
    func getOrderNumericalData(selectIndex:Int) {
        
        VClient.sharedInstance().VCGetOrderNumericalByOrderNo(order_No: self.orderNoArray[selectIndex]) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Any>) in
            
            if isSuccess {
                
                self.selectOrderNoStr = self.orderNoArray[selectIndex]
                self.selectTotalPrice = self.orderTotalPriceArray[selectIndex]
                let num:String = resDataArray[1] as? String ?? ""
                let orderNO:String = "\(self.orderNoArray[selectIndex])\(num)"
                let vc = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
                vc.orderNo = self.selectOrderNoStr
                vc.getUrl_OrderNo = orderNO
                vc.totalPayPrice = self.selectTotalPrice
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    //MARK:- Action

    @objc func leftBarBtnClick(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    @objc func orderNumValueBtnClick(_ sender:UIButton) {
        
        let statusSt:String = self.orderStatusArray[sender.tag]
        
        if statusSt == "訂單已付款" {
            let vc = OrderDoneDetailViewController(nibName: "OrderDoneDetailViewController", bundle: nil)
            vc.dataDict = self.getCheckoutDictData(selectIndex: sender.tag)
            vc.orderNoSt = self.orderNoArray[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = OrderConfirmViewController(nibName: "OrderConfirmViewController", bundle: nil)
            vc.dataDict = self.getCheckoutDictData(selectIndex: sender.tag)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func orderScheduleValueBtnClick(_ sender:UIButton) {
        
        let statusSt:String = self.orderStatusArray[sender.tag]
        
        if statusSt == "訂單已付款" {
            self.cav = CustomAlertView.init(title: "已付款", btnTitle:NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.cav.delegate = self
            self.view.addSubview(self.cav)
        }else{
            self.userDefault.set(1, forKey: "backDefault")
            self.getOrderNumericalData(selectIndex: sender.tag)
        }
    }
    
    @objc func freightValueBtnClick(_ sender:UIButton) {
        
        let urlSt:String = self.packageDeliveryUrlArray[sender.tag]
        if let url = URL(string: urlSt) {
            UIApplication.shared.open(url)
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
        
        return self.orderIDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:OrderListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderListTableViewCell
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let selectBkView = UIView()
        selectBkView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBkView

        let number:String = self.orderNoArray[indexPath.row]
        let deliveryCode:String = self.packageDeliveryCodeArray[indexPath.row]
        let statusSt:String = self.orderStatusArray[indexPath.row]
        
        if statusSt == "訂單已付款" {
            cell.loadData(orderNumSt: number, scheduleSt: statusSt, freightNum: deliveryCode)
        }else{
            cell.loadData(orderNumSt: number, scheduleSt: NSLocalizedString("Order_Go_Pay_Btn_title", comment: ""), freightNum: deliveryCode)
        }
        
        cell.orderNumValueBtn.tag = indexPath.row
        cell.orderNumValueBtn.addTarget(self, action: #selector(orderNumValueBtnClick(_:)), for: .touchUpInside)
        
        cell.orderScheduleValueBtn.tag = indexPath.row
        cell.orderScheduleValueBtn.addTarget(self, action: #selector(orderScheduleValueBtnClick(_:)), for: .touchUpInside)
        
        cell.freightValueBtn.tag = indexPath.row
        cell.freightValueBtn.addTarget(self, action: #selector(freightValueBtnClick(_:)), for: .touchUpInside)

        return cell
    }
    
    //MARK: - CustomAlertViewDelegate
    
    func alertBtnClick(btnTag: Int) {
        self.cav.removeFromSuperview()
    }

}
