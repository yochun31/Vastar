//
//  CheckoutViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/7/2.
//

import UIKit

class CheckoutViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var selectTitleLabel: UILabel!
    
    @IBOutlet var selectProductTableView: UITableView!
    
    @IBOutlet var payTitleLabel: UILabel!
    @IBOutlet var payTextField: UITextField!
    
    @IBOutlet var transportTitleLabel: UILabel!
    @IBOutlet var transportTextField: UITextField!
    

    @IBOutlet var receiverTitleLabel: UILabel!
    @IBOutlet var receiverTextField: UITextField!
    @IBOutlet var receiverNameTextField: UITextField!
    @IBOutlet var receiverPhoneTextField: UITextField!

    
    @IBOutlet var addressTitleLabel: UILabel!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var townTextField: UITextField!
    @IBOutlet var posttalCodeTextField: UITextField!
    @IBOutlet var addressDetailTitleLabel: UILabel!
    @IBOutlet var addressDetailTextField: UITextField!
    
    @IBOutlet var orderTitleLabel: UILabel!
    
    @IBOutlet var totalTitleLabel: UILabel!
    @IBOutlet var totalValueLabel: UILabel!
    
    @IBOutlet var feeTitleLabel: UILabel!
    @IBOutlet var feeValueLabel: UILabel!
    
    @IBOutlet var moneyTitleLabel: UILabel!
    @IBOutlet var moneyValueLabel: UILabel!
    
    @IBOutlet var confirmBtn: UIButton!
    
    private var payPickerContainer = UIView()
    private var payPickerView = UIPickerView()
    private var receiverPickerContainer = UIView()
    private var receiverPickerView = UIPickerView()
    private var cityPickerContainer = UIView()
    private var cityPickerView = UIPickerView()
    private var townPickerContainer = UIView()
    private var townPickerView = UIPickerView()
    
    private var payDataArray:Array<String> = []
    private var receiverDataArray:Array<String> = []
    private var cityDataArray:Array<String> = []
    private var townDataArray:Array<String> = []
    
    private var selectPaySt:String = ""
    private var selectReceiverSt:String = ""
    private var selectCitySt:String = ""
    private var selectTownSt:String = ""
    
    private var vaiv = VActivityIndicatorView()
    
    private var IDArray:Array<Int> = []
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
    
    var accountPhone:String = ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
        setTableView()
        createPayPickerView()
        createReceiverPickerView()
        createCityPickerView()
        createTownPickerView()
        getShoppingCarData()
        getReceiverData()
        getCityData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initializeInputView()
    }

    
    //MARK: - UI Interface Methods
    
    func setInterface() {
        
        self.navigationItem.title = NSLocalizedString("Shopping_Checkout_title", comment: "")
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.contentView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        self.selectTitleLabel.text = NSLocalizedString("Shopping_Checkout_Select_Product_title", comment: "")
        self.selectTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.payTitleLabel.text = NSLocalizedString("Shopping_Checkout_Pay_title", comment: "")
        self.payTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        self.payTextField.placeholder = NSLocalizedString("Shopping_Checkout_Select_Pay_title", comment: "")
        self.payTextField.inputAccessoryView = UIView()
        
        self.transportTitleLabel.text = NSLocalizedString("Shopping_Checkout_Transport_title", comment: "")
        self.transportTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.transportTextField.isEnabled = false
        self.transportTextField.text = NSLocalizedString("Shopping_Checkout_Home_Delivery_title", comment: "")

        self.receiverTitleLabel.text = NSLocalizedString("Shopping_Checkout_Recipient_title", comment: "")
        self.receiverTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        self.receiverTextField.placeholder = NSLocalizedString("", comment: "")
        self.receiverTextField.inputAccessoryView = UIView()
        self.receiverNameTextField.placeholder = NSLocalizedString("Shopping_Checkout_Recipient_title", comment: "")
        self.receiverPhoneTextField.placeholder = NSLocalizedString("Shopping_Checkout_Recipient_Phone_title", comment: "")

        
        self.addressTitleLabel.text = NSLocalizedString("Shopping_Checkout_Address_title", comment: "")
        self.addressTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.cityTextField.inputAccessoryView = UIView()
        self.townTextField.inputAccessoryView = UIView()
        
        self.posttalCodeTextField.placeholder = NSLocalizedString("Shopping_Checkout_Address_Posttal_Code_title", comment: "")

        
        self.addressDetailTitleLabel.text = NSLocalizedString("Shopping_Checkout_Address_Detail_title", comment: "")
        self.addressDetailTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)

        
        self.orderTitleLabel.text = NSLocalizedString("Shopping_Checkout_Order_title", comment: "")
        self.orderTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.totalTitleLabel.text = NSLocalizedString("Shopping_Checkout_Total_title", comment: "")
        self.totalTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        self.totalValueLabel.text = NSLocalizedString("", comment: "")
        self.totalValueLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        self.feeTitleLabel.text = NSLocalizedString("Shopping_Checkout_Fee_title", comment: "")
        self.feeTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        self.feeValueLabel.text = NSLocalizedString("", comment: "")
        self.feeValueLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        self.moneyTitleLabel.text = NSLocalizedString("Shopping_Checkout_Money_title", comment: "")
        self.moneyTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        self.moneyValueLabel.text = NSLocalizedString("", comment: "")
        self.moneyValueLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.confirmBtn.setTitle(NSLocalizedString("Shopping_Checkout_Confirm_Btn_title", comment: ""), for: .normal)
        self.confirmBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        
        self.payDataArray = ["信用卡"]
    }
    
    func setTableView() {
        
        self.selectProductTableView.delegate = self
        self.selectProductTableView.dataSource = self
        self.selectProductTableView.separatorStyle = .none
        
        self.selectProductTableView.register(UINib(nibName: "CheckoutProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutProductCell")
        self.selectProductTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    func createPayPickerView() {
        let size = UIScreen.main.bounds
        self.payPickerContainer = UIView(frame: CGRect(x: 0, y: size.size.height - 150, width: size.size.width, height: 250))
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.size.width, height: 20))
        pickerToolBar.barStyle = .default
        pickerToolBar.sizeToFit()
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(title: NSLocalizedString("Member_Select_Btn_title", comment: ""), style: .done, target: self, action: #selector(payDoneBtnClick(_:)))

        pickerToolBar.items = [leftBarButton,rightBarButton]
        self.payPickerContainer.addSubview(pickerToolBar)
        
        self.payPickerView = UIPickerView(frame: CGRect(x: 0, y: pickerToolBar.frame.size.height, width: size.size.width, height: self.payPickerContainer.frame.size.height - pickerToolBar.frame.size.height))
        self.payPickerView.dataSource = self
        self.payPickerView.delegate = self
        
        self.payPickerContainer.addSubview(self.payPickerView)
        self.view.addSubview(self.payPickerContainer)
    }
    
    func createReceiverPickerView() {
        let size = UIScreen.main.bounds
        self.receiverPickerContainer = UIView(frame: CGRect(x: 0, y: size.size.height - 150, width: size.size.width, height: 250))
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.size.width, height: 20))
        pickerToolBar.barStyle = .default
        pickerToolBar.sizeToFit()
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(title: NSLocalizedString("Member_Select_Btn_title", comment: ""), style: .done, target: self, action: #selector(receiverDoneBtnClick(_:)))

        pickerToolBar.items = [leftBarButton,rightBarButton]
        self.receiverPickerContainer.addSubview(pickerToolBar)
        
        self.receiverPickerView = UIPickerView(frame: CGRect(x: 0, y: pickerToolBar.frame.size.height, width: size.size.width, height: self.receiverPickerContainer.frame.size.height - pickerToolBar.frame.size.height))
        self.receiverPickerView.dataSource = self
        self.receiverPickerView.delegate = self
        
        self.receiverPickerContainer.addSubview(self.receiverPickerView)
        self.view.addSubview(self.receiverPickerContainer)
    }
    
    func createCityPickerView() {
        let size = UIScreen.main.bounds
        self.cityPickerContainer = UIView(frame: CGRect(x: 0, y: size.size.height - 150, width: size.size.width, height: 250))
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.size.width, height: 20))
        pickerToolBar.barStyle = .default
        pickerToolBar.sizeToFit()
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(title: NSLocalizedString("Member_Select_Btn_title", comment: ""), style: .done, target: self, action: #selector(cityDoneBtnClick(_:)))

        pickerToolBar.items = [leftBarButton,rightBarButton]
        self.cityPickerContainer.addSubview(pickerToolBar)
        
        self.cityPickerView = UIPickerView(frame: CGRect(x: 0, y: pickerToolBar.frame.size.height, width: size.size.width, height: self.cityPickerContainer.frame.size.height - pickerToolBar.frame.size.height))
        self.cityPickerView.dataSource = self
        self.cityPickerView.delegate = self
        
        self.cityPickerContainer.addSubview(self.cityPickerView)
        self.view.addSubview(self.cityPickerContainer)
    }
    
    func createTownPickerView() {
        let size = UIScreen.main.bounds
        self.townPickerContainer = UIView(frame: CGRect(x: 0, y: size.size.height - 150, width: size.size.width, height: 250))
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.size.width, height: 20))
        pickerToolBar.barStyle = .default
        pickerToolBar.sizeToFit()
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(title: NSLocalizedString("Member_Select_Btn_title", comment: ""), style: .done, target: self, action: #selector(townDoneBtnClick(_:)))

        pickerToolBar.items = [leftBarButton,rightBarButton]
        self.townPickerContainer.addSubview(pickerToolBar)
        
        self.townPickerView = UIPickerView(frame: CGRect(x: 0, y: pickerToolBar.frame.size.height, width: size.size.width, height: self.townPickerContainer.frame.size.height - pickerToolBar.frame.size.height))
        self.townPickerView.dataSource = self
        self.townPickerView.delegate = self
        
        self.townPickerContainer.addSubview(self.townPickerView)
        self.view.addSubview(self.townPickerContainer)
    }
    
    func initializeInputView() {
        
        self.payTextField.inputView = self.payPickerContainer
        self.payPickerContainer.removeFromSuperview()
        
        self.receiverTextField.inputView = self.receiverPickerContainer
        self.receiverPickerContainer.removeFromSuperview()
        
        self.cityTextField.inputView = self.cityPickerContainer
        self.cityPickerContainer.removeFromSuperview()
        
        self.townTextField.inputView = self.townPickerContainer
        self.townPickerContainer.removeFromSuperview()
    }
    
    
    //MARK:- Assistant Methods
    
    func getShoppingCarData() {
        
        self.IDArray.removeAll()
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
                    self.titleArray = dataArray[1] as? Array<String> ?? []
                    self.colorArray = dataArray[2] as? Array<String> ?? []
                    self.amountArray = dataArray[3] as? Array<Int> ?? []
                    self.vArray = dataArray[4] as? Array<String> ?? []
                    self.priceArray = dataArray[5] as? Array<Int> ?? []
                    self.photoArray = dataArray[6] as? Array<UIImage> ?? []
                    self.selectProductTableView.reloadData()
                    self.getSum()
                }
            }
        }
    }
    
    func getSum() {
        
        var countProduct:Int = 0
        var countProductPrice:Int = 0
        for i in 0 ..< self.amountArray.count {
            
            countProduct = countProduct + self.amountArray[i]
            countProductPrice = countProductPrice + (self.amountArray[i] * self.priceArray[i])
        }
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let countProductPriceSt:String = format.string(from: NSNumber(value:countProductPrice)) ?? ""
        let feePricr:Int = 450
        
        let moneySt:String = format.string(from: NSNumber(value:countProductPrice + feePricr)) ?? ""

        self.totalValueLabel.text = "$\(countProductPriceSt)"
        self.feeValueLabel.text = "$\(feePricr)"
        self.moneyValueLabel.text = "$\(moneySt)"
    }
    
    func getReceiverData() {
        
        self.receiverIDArray.removeAll()
        self.receiverNameArray.removeAll()
        self.receiverPhoneArray.removeAll()
        self.receiverCityArray.removeAll()
        self.receiverDistrictArray.removeAll()
        self.receiverAddressArray.removeAll()
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCGetReceiverData(phone: self.accountPhone) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            
            if isSuccess {
                if resDataArray.count != 0 {
                    self.receiverIDArray = resDataArray[0] as? Array<Int> ?? []
                    self.receiverNameArray = resDataArray[1] as? Array<String> ?? []
                    self.receiverPhoneArray = resDataArray[2] as? Array<String> ?? []
                    self.receiverCityArray = resDataArray[3] as? Array<String> ?? []
                    self.receiverDistrictArray = resDataArray[4] as? Array<String> ?? []
                    self.receiverAddressArray = resDataArray[5] as? Array<String> ?? []
                }
                self.receiverDataArray = self.receiverNameArray
                self.vaiv.stopProgressHUD(view: self.view)
                self.receiverPickerView.reloadComponent(0)
            }
        }
    }
    
    func GetPayPickerViewSelect() {
        let component = self.payPickerView.selectedRow(inComponent: 0)
        if self.payDataArray.count != 0 {
            self.selectPaySt = self.payDataArray[component]
            self.payTextField.text = self.selectPaySt
        }
    }
    
    func GetReceiverPickerViewSelect() {
        let component = self.receiverPickerView.selectedRow(inComponent: 0)
        if self.receiverDataArray.count != 0 {
            self.selectReceiverSt = self.receiverDataArray[component]
            self.receiverTextField.text = self.selectReceiverSt
            
            self.receiverNameTextField.text = self.receiverNameArray[component]
            self.receiverPhoneTextField.text = self.receiverPhoneArray[component]
            
            self.cityTextField.text = self.receiverCityArray[component]
            self.townTextField.text = self.receiverDistrictArray[component]
            self.addressDetailTextField.text = self.receiverAddressArray[component]
            
            getTownData(citySt: self.cityTextField.text ?? "")
        }
    }
    
    
    func getCityData() {
        VClient.sharedInstance().VCGetCityData { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) in
            
            if isSuccess {
                self.cityDataArray = resDataArray
                print("\(self.cityDataArray)")
                self.cityPickerView.reloadComponent(0)
            }
        }
    }
    
    func getTownData(citySt:String) {
        
        VClient.sharedInstance().VCGetDistrictData(city: citySt) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) in
            if isSuccess {
                self.townDataArray = resDataArray
                self.townPickerView.reloadComponent(0)
            }
        }
    }
    
    func GetCityPickerViewSelect() {
        let component = self.cityPickerView.selectedRow(inComponent: 0)
        if self.cityDataArray.count != 0 {
            self.selectCitySt = self.cityDataArray[component]
            self.cityTextField.text = self.selectCitySt
        }
        getTownData(citySt: self.selectCitySt)
    }
    
    
    func GetTownPickerViewSelect() {
        let component = self.townPickerView.selectedRow(inComponent: 0)
        if self.townDataArray.count != 0 {
            self.selectTownSt = self.townDataArray[component]
            self.townTextField.text = self.selectTownSt
        }
    }
    
    //MARK:- Action
    
    @objc func payDoneBtnClick(_ sender:UIButton) {
        self.view.endEditing(true)
        GetPayPickerViewSelect()
    }
    
    @objc func receiverDoneBtnClick(_ sender:UIButton) {
        self.view.endEditing(true)
        GetReceiverPickerViewSelect()
    }
    
    @objc func cityDoneBtnClick(_ sender:UIButton) {
        self.view.endEditing(true)
        self.GetCityPickerViewSelect()
        self.townTextField.text = ""
    }
    
    @objc func townDoneBtnClick(_ sender:UIButton) {
        self.view.endEditing(true)
        self.GetTownPickerViewSelect()
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
    
    
    //MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var result:Int = 0
        
        switch component {
        case 0:
            if pickerView == self.payPickerView {
                result = self.payDataArray.count
            }else if pickerView == self.receiverPickerView {
                result = self.receiverDataArray.count
            }else if pickerView == self.cityPickerView {
                result = self.cityDataArray.count
            }else if pickerView == self.townPickerView {
                result = self.townDataArray.count
            }
            break
        default:
            break
        }
        
        return result
    }
    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title:String = ""
        switch component {
        case 0:
            
            if pickerView == self.payPickerView {
                title =  self.payDataArray[row]
            }else if pickerView == self.receiverPickerView {
                title = self.receiverDataArray[row]
            }else if pickerView == self.cityPickerView {
                title =  self.cityDataArray[row]
            }else if pickerView == self.townPickerView {
                title = self.townDataArray[row]
            }
            break
        default:
            break
        }
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

}
