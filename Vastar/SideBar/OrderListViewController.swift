//
//  OrderListViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/7/9.
//

import UIKit

class OrderListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
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
    
    var accountPhone:String = ""
    
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
    
    
    //MARK: - UI Interface Methods
    
    func setLeftBarButton() {
        let leftBarBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBarBtn.setImage(UIImage(named: "menu"), for: .normal)
        leftBarBtn.addTarget(self, action: #selector(leftBarBtnClick(_:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem(customView: leftBarBtn)
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
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
                    
                    self.orderTableView.reloadData()
                }
            }
        }
    }
    
    
    //MARK:- Action

    @objc func leftBarBtnClick(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
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
        
        cell.loadData(orderNumSt: number, scheduleSt: "")

        return cell
    }

}
