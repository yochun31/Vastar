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
        
    @IBOutlet var totalProductTitleLabel: UILabel!
    @IBOutlet var totalProductValueLabel: UILabel!
    
    @IBOutlet var feeTitleLabel: UILabel!
    @IBOutlet var feeValueLabel: UILabel!
    
    @IBOutlet var totalPriceTitleLabel: UILabel!
    @IBOutlet var totalPriceValueLabel: UILabel!
    
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
    
    private var current_Sum_Product_Price:Int = 0
    private var sum_MainPrice:Int = 0
    private var sum_OutlyingPrice:Int = 0
    
    private var final_totalProduct:Int = 0
    private var final_fee:Int = 0
    private var final_total:Int = 0
    
    private var doneFlagArray:Array<Bool> = []
    
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
        getPayMethodData()
        getShoppingCarData()
        getReceiverData()
        getCityData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initializeInputView()
    }

    
    //MARK: - UI Interface Methods
    
    // 設定UI介面
    
    func setInterface() {
        
        self.navigationItem.title = NSLocalizedString("Shopping_Checkout_title", comment: "")
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.contentView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        let placeHolderTextColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let textColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let lineColor:UIColor = UIColor.darkGray
        let font:UIFont = UIFont.systemFont(ofSize: 15.0)
        
        self.selectTitleLabel.text = NSLocalizedString("Shopping_Checkout_Select_Product_title", comment: "")
        self.selectTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.selectTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.payTitleLabel.text = NSLocalizedString("Shopping_Checkout_Pay_title", comment: "")
        self.payTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.payTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.payTextField.inputAccessoryView = UIView()
        self.payTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.payTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Shopping_Checkout_Select_Pay_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.payTextField.setTextColor(textColor, font: font)
        
        self.transportTitleLabel.text = NSLocalizedString("Shopping_Checkout_Transport_title", comment: "")
        self.transportTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.transportTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.transportTextField.isEnabled = false
        self.transportTextField.text = NSLocalizedString("Shopping_Checkout_Home_Delivery_title", comment: "")
        self.transportTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.transportTextField.setTextColor(textColor, font: font)

        self.receiverTitleLabel.text = NSLocalizedString("Shopping_Checkout_Recipient_title", comment: "")
        self.receiverTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.receiverTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.receiverTextField.placeholder = NSLocalizedString("", comment: "")
        self.receiverTextField.inputAccessoryView = UIView()
        self.receiverTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.receiverTextField.setTextColor(textColor, font: font)
        
        self.receiverNameTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.receiverNameTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Shopping_Checkout_Recipient_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.receiverNameTextField.setTextColor(textColor, font: font)
        
        self.receiverPhoneTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.receiverPhoneTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Shopping_Checkout_Recipient_Phone_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.receiverPhoneTextField.setTextColor(textColor, font: font)
        
        self.addressTitleLabel.text = NSLocalizedString("Shopping_Checkout_Address_title", comment: "")
        self.addressTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.addressTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.cityTextField.inputAccessoryView = UIView()
        self.cityTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.cityTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Shopping_Checkout_Address_City_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.cityTextField.setTextColor(textColor, font: font)
        
        self.townTextField.inputAccessoryView = UIView()
        self.townTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.townTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Shopping_Checkout_Address_Town_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.townTextField.setTextColor(textColor, font: font)
        
        self.posttalCodeTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.posttalCodeTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Shopping_Checkout_Address_Posttal_Code_title", comment: ""), colour: placeHolderTextColor, font: font)
        self.posttalCodeTextField.setTextColor(textColor, font: font)

        
        self.addressDetailTitleLabel.text = NSLocalizedString("Shopping_Checkout_Address_Detail_title", comment: "")
        self.addressDetailTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.addressDetailTitleLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.addressDetailTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
        self.addressDetailTextField.setTextColor(textColor, font: font)

        
        self.orderTitleLabel.text = NSLocalizedString("Shopping_Checkout_Order_title", comment: "")
        self.orderTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.totalProductTitleLabel.text = NSLocalizedString("Shopping_Checkout_Total_title", comment: "")
        self.totalProductTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.totalProductValueLabel.text = NSLocalizedString("", comment: "")
        self.totalProductValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.feeTitleLabel.text = NSLocalizedString("Shopping_Checkout_Fee_title", comment: "")
        self.feeTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.feeValueLabel.text = NSLocalizedString("", comment: "")
        self.feeValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.totalPriceTitleLabel.text = NSLocalizedString("Shopping_Checkout_Money_title", comment: "")
        self.totalPriceTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.totalPriceValueLabel.text = NSLocalizedString("", comment: "")
        self.totalPriceValueLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.confirmBtn.setTitle(NSLocalizedString("Shopping_Checkout_Confirm_Btn_title", comment: ""), for: .normal)
        self.confirmBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnClick(_:)), for: .touchUpInside)
        
    }
    
    // 設定TableView
    
    func setTableView() {
        
        self.selectProductTableView.delegate = self
        self.selectProductTableView.dataSource = self
        self.selectProductTableView.separatorStyle = .none
        
        self.selectProductTableView.register(UINib(nibName: "CheckoutProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckoutProductCell")
        self.selectProductTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    // 建立付款方式 PickerView
    
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
    
    // 建立收件人 PickerView
    
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
    
    // 建立City PickerView
    
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
    
    // 建立鄉鎮區 PickerView
    
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
    
    // 取得付款方式資料
    
    func getPayMethodData() {
        
        VClient.sharedInstance().VCGetPayMethodData { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) in
            
            if isSuccess {
                if resDataArray.count != 0 {
                    self.payDataArray = resDataArray
                    self.payPickerView.reloadComponent(0)
                }
            }
        }
    }
    
    // 取得購物車資料
    
    func getShoppingCarData() {
        
        sum_MainPrice = 0
        sum_OutlyingPrice = 0
        
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
                    self.selectProductTableView.reloadData()
                    self.getShippingData()
                }
            }
        }
    }
    
    // 計算購物車價錢總和
    
    func getSum() {
        
        var countProduct:Int = 0
        var countProductPrice:Int = 0
        for i in 0 ..< self.amountArray.count {
            
            countProduct = countProduct + self.amountArray[i]
            countProductPrice = countProductPrice + (self.amountArray[i] * self.priceArray[i])
            self.current_Sum_Product_Price = countProductPrice
            self.final_totalProduct = countProductPrice
        }
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let countProductPriceSt:String = format.string(from: NSNumber(value:countProductPrice)) ?? ""
        let feePricr:Int = sum_MainPrice
        self.final_fee = feePricr
        
        let totalSt:String = format.string(from: NSNumber(value:countProductPrice + feePricr)) ?? ""
        self.final_total = countProductPrice + feePricr

        self.totalProductValueLabel.text = "$\(countProductPriceSt)"
        self.feeValueLabel.text = "$\(feePricr)"
        self.totalPriceValueLabel.text = "$\(totalSt)"

    }
    
    // 取得收件人資料
    
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
    

    
    // 取得City資料
    
    func getCityData() {
        VClient.sharedInstance().VCGetCityData { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) in
            
            if isSuccess {
                self.cityDataArray = resDataArray
                self.cityPickerView.reloadComponent(0)
            }
        }
    }
    
    // 取得鄉鎮區資料
    
    func getTownData(citySt:String) {
        
        VClient.sharedInstance().VCGetDistrictData(city: citySt) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) in
            if isSuccess {
                self.townDataArray = resDataArray
                self.townPickerView.reloadComponent(0)
            }
        }
    }
    
    // 取得郵遞區號資料
    
    func getPostalCodeData(citySt:String,townSt:String) {
        
        VClient.sharedInstance().VCGetPostalCodeData(city: citySt, town: townSt) { (_ isSuccess:Bool,_ message:String,_ resData:String,_ isOutlying:Int) in
            if isSuccess {
                self.posttalCodeTextField.text = resData
                
                if isOutlying == 1 {
                    self.feeValueLabel.text = "$\(self.sum_OutlyingPrice)"
                    self.final_fee = self.sum_OutlyingPrice
                    let format = NumberFormatter()
                    format.numberStyle = .decimal
                    let totalSt:String = format.string(from: NSNumber(value:self.current_Sum_Product_Price + self.sum_OutlyingPrice)) ?? ""
                    self.totalPriceValueLabel.text = "$\(totalSt)"
                    self.final_total = self.current_Sum_Product_Price + self.sum_OutlyingPrice
                }else{
                    self.feeValueLabel.text = "$\(self.sum_MainPrice)"
                    self.final_fee = self.sum_MainPrice
                    let format = NumberFormatter()
                    format.numberStyle = .decimal
                    let totalSt:String = format.string(from: NSNumber(value:self.current_Sum_Product_Price + self.sum_MainPrice)) ?? ""
                    self.totalPriceValueLabel.text = "$\(totalSt)"
                    self.final_total = self.current_Sum_Product_Price + self.sum_MainPrice
                }
            }
        }
    }
    
    // 取得付款方式下拉選單 選中值
    
    func GetPayPickerViewSelect() {
        let component = self.payPickerView.selectedRow(inComponent: 0)
        if self.payDataArray.count != 0 {
            self.selectPaySt = self.payDataArray[component]
            self.payTextField.text = self.selectPaySt
        }
    }
    
    // 取得收件人下拉選單 選中值
    
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
            getPostalCodeData(citySt: self.cityTextField.text ?? "", townSt: self.townTextField.text ?? "")
        }
    }
    
    // 取得City下拉選單 選中值
    
    func GetCityPickerViewSelect() {
        let component = self.cityPickerView.selectedRow(inComponent: 0)
        if self.cityDataArray.count != 0 {
            self.selectCitySt = self.cityDataArray[component]
            self.cityTextField.text = self.selectCitySt
        }
        getTownData(citySt: self.selectCitySt)
    }
    
    // 取得鄉鎮區下拉選單 選中值
    
    func GetTownPickerViewSelect() {
        let component = self.townPickerView.selectedRow(inComponent: 0)
        if self.townDataArray.count != 0 {
            self.selectTownSt = self.townDataArray[component]
            self.townTextField.text = self.selectTownSt
        }
        let city:String = self.cityTextField.text ?? ""
        getPostalCodeData(citySt: city, townSt: self.selectTownSt)
    }
    
    // 計算運費(本島/離島)
    
    func getShippingData() {
        
        for i in 0 ..< self.IDArray.count {
            
            let noSt:String = self.NoArray[i]
            let amount:Int = self.amountArray[i]
            print("---\(noSt)  -- \(amount)")
            VClient.sharedInstance().VCGetShippingData(productNo: noSt) { (_ isSuccess:Bool,_ message:String,_ mainPrice:Int,_ OutlyingPrice:Int) in
                if isSuccess {
                    print("main =\(mainPrice) Out = \(OutlyingPrice)")
                    let main:Int = mainPrice * amount
                    let out:Int = OutlyingPrice * amount
                    self.checkGetShippingDataDone(doneFlag: true, mainPrice: main, OutPrice: out)
                }
            }
        }
    }
    
    // 檢查運費資料是否完成取得
    
    func checkGetShippingDataDone(doneFlag:Bool,mainPrice:Int,OutPrice:Int) {
        
        self.doneFlagArray.append(doneFlag)
        print(self.doneFlagArray)
        
        sum_MainPrice = sum_MainPrice + mainPrice
        sum_OutlyingPrice = sum_OutlyingPrice + OutPrice
        
        if self.doneFlagArray.count == self.IDArray.count {
            self.doneFlagArray = []
            getSum()
        }
    }
    
    // 建立新增結帳資料 Dict
    
    func getCheckoutDictData() -> [String:Any] {
        var dictData:[String:Any] = [:]
        
        let pay:String = self.payTextField.text ?? ""
        let transport:String = self.transportTextField.text ?? ""
        let name:String = self.receiverNameTextField.text ?? ""
        let phone:String = self.receiverPhoneTextField.text ?? ""
        let city:String = self.cityTextField.text ?? ""
        let town:String = self.townTextField.text ?? ""
        let postalCode:String = self.posttalCodeTextField.text ?? ""
        let address:String = self.addressDetailTextField.text ?? ""
        let totalProduct:Int = self.final_totalProduct 
        let fee:Int = self.final_fee 
        let total:Int = self.final_total
        
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDateString = dateFormatter.string(from: todayDate)
        
        
        dictData.updateValue("vastar", forKey: "UserID")
        dictData.updateValue("vastar@2673", forKey: "Password")
        dictData.updateValue("", forKey: "Order_No")
        dictData.updateValue(accountPhone, forKey: "Account_Name")
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
        dictData.updateValue(nowDateString, forKey: "OrderEstablishTime")
        dictData.updateValue("訂單已送出", forKey: "Order_Status")
        
        return dictData
    }
    
    //檢查輸入資料
    
    func checkInputData() {
        
        let pay = self.payTextField.text ?? ""
        let receiver = self.receiverTextField.text ?? ""
        let receiverName = self.receiverNameTextField.text ?? ""
        let receiverPhone = self.receiverPhoneTextField.text ?? ""
        let city = self.cityTextField.text ?? ""
        let town = self.townTextField.text ?? ""
        let posttalCode = self.posttalCodeTextField.text ?? ""
        let addressDetail = self.addressDetailTextField.text ?? ""
        
        if pay.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Shopping_Checkout_Select_Pay_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if receiver.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Shopping_Checkout_Input_Reciver_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if receiverName.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Shopping_Checkout_Input_Reciver_Name_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if receiverPhone.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Shopping_Checkout_Input_Reciver_Phone_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if city.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Shopping_Checkout_Select_Reciver_City_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if town.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Shopping_Checkout_Select_Reciver_Town_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if posttalCode.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Shopping_Checkout_Select_PostalCode_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else if addressDetail.count == 0 {
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Shopping_Checkout_Input_Address_Alert_Text", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            
        }else{
            let vc = ConfirmOrderViewController(nibName: "ConfirmOrderViewController", bundle: nil)
            vc.dataDict = self.getCheckoutDictData()
            self.navigationController?.pushViewController(vc, animated: true)
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
        self.posttalCodeTextField.text = ""
    }
    
    @objc func townDoneBtnClick(_ sender:UIButton) {
        self.view.endEditing(true)
        self.GetTownPickerViewSelect()
    }
    
    @objc func confirmBtnClick(_ sender:UIButton) {
        
        checkInputData()
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
