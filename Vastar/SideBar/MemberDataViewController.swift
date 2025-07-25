//
//  MemberDataViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import UIKit
import LocalAuthentication

class MemberDataViewController: UIViewController,RecipientAddViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CustomAlertViewDelegate,CustomAlertTwoBtnViewDelegate,CustomAlertTextFiledViewDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var birthdayTextField: UITextField!
    
    @IBOutlet var telLabel: UILabel!
    @IBOutlet var telTextField: UITextField!
    
    @IBOutlet var mobilePhoneLabel: UILabel!
    @IBOutlet var mobilePhoneTextField: UITextField!
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var addressTextField: UITextField!
    
    @IBOutlet weak var biometricLabel: UILabel!
    @IBOutlet weak var biometricInfoLabel: UILabel!
    @IBOutlet weak var biometricSwitch: UISwitch!
    
    @IBOutlet var editBtn_Name: UIButton!
    @IBOutlet var setDateBtn: CustomButton!
    @IBOutlet var editBtn_Tel: UIButton!
    @IBOutlet var editBtn_Phone: UIButton!
    @IBOutlet var editBtn_Address: UIButton!
    
    @IBOutlet var recipientLabel: UILabel!
    @IBOutlet var addBtn_Recipient: UIButton!
    
    @IBOutlet var receiverTableView: UITableView!
    @IBOutlet var viewContainer: UIView!
    
    private var datePickerContainer = UIView()
    private var datePickerView = UIDatePicker()
    
    private var userName:String = ""
    private var userBirthday:String = ""
    private var userTel:String = ""
    private var userMobilePhone:String = ""
    private var userAddress:String = ""
    private var userRegisterTime = ""
    
    private var currentNameEditStatus:Int = -1
    private var currentTelEditStatus:Int = -1
    private var currentPhoneEditStatus:Int = -1
    private var currentAddressEditStatus:Int = -1
    
    private var dateStaring:String = ""

    private var vaiv = VActivityIndicatorView()
    private var rav = RecipientAddView()
    private var cav = CustomAlertView()
    private var cavt = CustomAlertTwoBtnView()
    private var catf = CustomAlertTextFiledView()
    
    private var receiverIDArray:Array<Int> = []
    private var receiverNameArray:Array<String> = []
    private var receiverPhoneArray:Array<String> = []
    private var receiverCityArray:Array<String> = []
    private var receiverDistrictArray:Array<String> = []
    private var receiverAddressArray:Array<String> = []
    
    private var deleteTag:Int = 0
    
    let AppInfo = AppInfoManager()
    
    var accountPhone:String = ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLeftBarButton()
        setInterface()
        setupSWReveal()
        setReceiverTableView()
        createDatePickerView()
        getUserInfo(accountName: accountPhone)
        getReceiverData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initializeInputView()
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
    
    func setupSWReveal(){
        //adding panGesture to reveal menu controller
        view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        //adding tap gesture to hide menu controller
        view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        //setting reveal width of menu controller manually
        self.revealViewController()?.rearViewRevealWidth = UIScreen.main.bounds.width * (2/3)
    }
    
    // 設定UI介面
    
    func setInterface() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.viewContainer.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        self.navigationItem.title = NSLocalizedString("Member_title", comment: "")
        
        self.nameLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.nameLabel.text = NSLocalizedString("Member_Name_title", comment: "")
        self.nameLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.nameTextField.isEnabled = false
        self.nameTextField.borderStyle = .none
        self.nameTextField.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.nameTextField.font = UIFont.systemFont(ofSize: 17.0)
        
        self.birthdayLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.birthdayLabel.text = NSLocalizedString("Member_Birthday_title", comment: "")
        self.birthdayLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.birthdayTextField.placeholder = NSLocalizedString("Member_Birthday_Placeholder_title", comment: "")

        self.birthdayTextField.isEnabled = false
        self.birthdayTextField.borderStyle = .none
        self.birthdayTextField.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.birthdayTextField.font = UIFont.systemFont(ofSize: 13.0)
        
        self.telLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.telLabel.text = NSLocalizedString("Member_Tel_title", comment: "")
        self.telLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.telTextField.isEnabled = false
        self.telTextField.borderStyle = .none
        self.telTextField.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.telTextField.font = UIFont.systemFont(ofSize: 17.0)
        
        self.mobilePhoneLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.mobilePhoneLabel.text = NSLocalizedString("Member_Phone_title", comment: "")
        self.mobilePhoneLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.mobilePhoneTextField.isEnabled = false
        self.mobilePhoneTextField.borderStyle = .none
        self.mobilePhoneTextField.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.mobilePhoneTextField.font = UIFont.systemFont(ofSize: 17.0)
        
        self.addressLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.addressLabel.text = NSLocalizedString("Member_Address_title", comment: "")
        self.addressLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.addressTextField.isEnabled = false
        self.addressTextField.borderStyle = .none
        self.addressTextField.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.addressTextField.font = UIFont.systemFont(ofSize: 17.0)
        
        self.biometricLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.biometricLabel.text = NSLocalizedString("Member_Biometric_title", comment: "")
        self.biometricLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.biometricInfoLabel.text = NSLocalizedString("Member_Biometric_Info", comment: "")
        self.biometricInfoLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        let biometricStatus:Bool = UserDefaults.standard.bool(forKey: "C1")
        print("-----\(biometricStatus)")
        self.biometricSwitch.setOn(biometricStatus, animated: true)
        self.biometricSwitch.addTarget(self, action: #selector(biometricSwitchAction(_:)), for: .valueChanged)
        
        self.currentNameEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
        self.currentTelEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
        self.currentPhoneEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
        self.currentAddressEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
        
        self.editBtn_Name.setTitle(NSLocalizedString("Member_Edit_Btn_title", comment: ""), for: .normal)
        self.editBtn_Name.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.editBtn_Name.addTarget(self, action: #selector(editBtn_NameClick(_:)), for: .touchUpInside)
        
        self.setDateBtn.setTitle(NSLocalizedString("Member_Set_Date_Btn_title", comment: ""), for: .normal)
        self.setDateBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.setDateBtn.addTarget(self, action: #selector(setDateBtnClick(_:)), for: .touchUpInside)
        
        self.editBtn_Tel.setTitle(NSLocalizedString("Member_Edit_Btn_title", comment: ""), for: .normal)
        self.editBtn_Tel.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.editBtn_Tel.addTarget(self, action: #selector(editBtn_TelClick(_:)), for: .touchUpInside)
        
        self.editBtn_Phone.setTitle(NSLocalizedString("Member_Edit_Btn_title", comment: ""), for: .normal)
        self.editBtn_Phone.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.editBtn_Phone.addTarget(self, action: #selector(editBtn_PhoneClick(_:)), for: .touchUpInside)
        
        self.editBtn_Address.setTitle(NSLocalizedString("Member_Edit_Btn_title", comment: ""), for: .normal)
        self.editBtn_Address.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.editBtn_Address.addTarget(self, action: #selector(editBtn_AddressClick(_:)), for: .touchUpInside)
        
        self.recipientLabel.text = NSLocalizedString("Member_Recipient_title", comment: "")
        self.recipientLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.recipientLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        self.addBtn_Recipient.setTitle(NSLocalizedString("Member_Recipient_Btn_title", comment: ""), for: .normal)
        self.addBtn_Recipient.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.addBtn_Recipient.addTarget(self, action: #selector(addBtn_RecipientClick(_:)), for: .touchUpInside)
        
    }
    
    // 建立日期 PickerView
    
    func createDatePickerView() {
        
        let size = UIScreen.main.bounds
        self.datePickerContainer = UIView(frame: CGRect(x: 0, y: size.size.height - 150, width: size.size.width, height: 280))
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.size.width, height: 20))
        pickerToolBar.backgroundColor = UIColor.gray
        pickerToolBar.sizeToFit()
        let leftBarButton = UIBarButtonItem(title: NSLocalizedString(NSLocalizedString("Member_Cancel_Btn_title", comment: ""), comment: ""), style: .done, target: self, action: #selector(cancelBtnClick(_:)))

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(title: NSLocalizedString("Member_Confirm_Btn_title", comment: ""), style: .done, target: self, action: #selector(dateDoneBtnClick(_:)))
        
        pickerToolBar.items = [leftBarButton,flexibleSpace,rightBarButton]
        self.datePickerContainer.addSubview(pickerToolBar)
        
        self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: pickerToolBar.frame.size.height, width: size.size.width , height: self.datePickerContainer.frame.size.height - pickerToolBar.frame.size.height))
        
        self.datePickerView.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        self.datePickerView.datePickerMode = .date
        self.datePickerView.backgroundColor = UIColor.white
        if #available(iOS 13.4, *) {
            self.datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.datePickerView.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
        self.datePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.datePickerContainer.addSubview(self.datePickerView)
        self.view.addSubview(self.datePickerContainer)
        
        let top = NSLayoutConstraint(item: self.datePickerView, attribute: .top, relatedBy: .equal, toItem: pickerToolBar, attribute: .top, multiplier: 1.0, constant: 30.0)
        let left = NSLayoutConstraint(item: self.datePickerView, attribute: .left, relatedBy: .equal, toItem: self.datePickerContainer, attribute: .left, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: self.datePickerView, attribute: .right, relatedBy: .equal, toItem: self.datePickerContainer, attribute: .right, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: self.datePickerView, attribute: .bottom, relatedBy: .equal, toItem: self.datePickerContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.datePickerContainer.addConstraint(top)
        self.datePickerContainer.addConstraint(left)
        self.datePickerContainer.addConstraint(right)
        self.datePickerContainer.addConstraint(bottom)
        

    }
    
    func initializeInputView() {
        
        self.setDateBtn.inputView = self.datePickerContainer
        self.datePickerContainer.removeFromSuperview()
    }
    
    
    func setReceiverTableView() {
        
        self.receiverTableView.delegate = self
        self.receiverTableView.dataSource = self
        self.receiverTableView.separatorStyle = .none
        self.receiverTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    
        self.receiverTableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
    }
    
    
    //MARK: - Assistant Methods
    
    // 取得帳號資料
    
    func getUserInfo(accountName:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        
        VClient.sharedInstance().VCGetUserInfoByPhone(phone: accountName) { (_ isSuccess:Bool,_ message:String,_ isResult:Int,_ dictResData:[String:Any]) in
            
            if isSuccess {
                if isResult == 0 {
                    let name = dictResData["Name"] as? String ?? ""
                    let birthday = dictResData["Birthday"] as? String ?? ""
                    let tel = dictResData["Telephone"] as? String ?? ""
                    let phone = dictResData["MobilePhone"] as? String ?? ""
                    let address = dictResData["Address"] as? String ?? ""
                    let res_registerTime = dictResData["RegisterTime"] as? String ?? ""
                    self.userName = name
                    self.userBirthday = birthday
                    self.userTel = tel
                    self.userMobilePhone = phone
                    self.userAddress = address
                    self.userRegisterTime = res_registerTime
                    self.showUserInfo(nameSt: name, birthdaySt: birthday, telSt: tel, phone: phone, address: address)
                }
                
                self.vaiv.stopProgressHUD(view: self.view)
                
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
    }
    
    // 帳戶資料顯示設定
    
    func showUserInfo(nameSt:String,birthdaySt:String,telSt:String,phone:String,address:String) {
        
        self.nameTextField.text = nameSt
        
        if birthdaySt.count == 0 {
            self.setDateBtn.isHidden = false
            self.birthdayTextField.text = NSLocalizedString("Member_Birthday_Placeholder_title", comment: "")
        }else{
            self.setDateBtn.isHidden = true
            self.birthdayTextField.text = birthdaySt
        }
        self.telTextField.text = telSt
        self.mobilePhoneTextField.text = phone
        self.addressTextField.text = address
    }
    
    // 更新帳戶姓名
    
    func updateUserName(nameSt:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCUpdateChangeName(phone: self.accountPhone, name: nameSt) { (_ isSuccess:Bool,_ message:String) in
            if isSuccess {
                print(">>>\(message)<<<")
                self.vaiv.stopProgressHUD(view: self.view)
                
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
    }
    
    // 更新帳戶電話
    
    func updateUserTel(telSt:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCUpdateChangeTel(phone: self.accountPhone, tel: telSt) { (_ isSuccess:Bool,_ message:String) in
            if isSuccess {
                print(">>>\(message)<<<")
                self.vaiv.stopProgressHUD(view: self.view)
                
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
    }
    
    // 更新帳戶生日
    
    func updateUserBirthday(birthdaySt:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCUpdateChangeBirthday(phone: self.accountPhone, birthday: birthdaySt) { (_ isSuccess:Bool,_ message:String) in
            if isSuccess {
                print(">>>\(message)<<<")
                self.vaiv.stopProgressHUD(view: self.view)
                DispatchQueue.main.async {
                    self.getUserInfo(accountName: self.accountPhone)
                }
                
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
    }
    
    // 更新帳戶聯絡手機
    
    func updateUserMobilePhone(mobilePhoneSt:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCUpdateChangeMobilePhone(phone: self.accountPhone, mobilePhone: mobilePhoneSt) { (_ isSuccess:Bool,_ message:String) in
            
            if isSuccess {
                print(">>>\(message)<<<")
                self.vaiv.stopProgressHUD(view: self.view)
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
    }
    
    // 更新帳戶聯絡地址
    
    func updateUserAddress(addressSt:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCUpdateChangeAddress(phone: self.accountPhone, address: addressSt) { (_ isSuccess:Bool,_ message:String) in
            
            if isSuccess {
                print(">>>\(message)<<<")
                self.vaiv.stopProgressHUD(view: self.view)
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
    }
    
    // 編輯按鈕顯示設定
    
    func editBtnStatus(item:Int,textField:UITextField) {
        
        let backgroundColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let lineColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)

        switch item {
        case VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue:
            
            if textField == self.nameTextField {
                self.currentNameEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnConfirm.rawValue
                self.editBtn_Name.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentNameEditStatus), for: .normal)
            }else if textField == self.telTextField {
                self.currentTelEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnConfirm.rawValue
                self.editBtn_Tel.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentTelEditStatus), for: .normal)
            }else if textField == self.mobilePhoneTextField {
                self.currentPhoneEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnConfirm.rawValue
                self.editBtn_Phone.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentPhoneEditStatus), for: .normal)
            }else if textField == self.addressTextField {
                self.currentAddressEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnConfirm.rawValue
                self.editBtn_Address.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentAddressEditStatus), for: .normal)
            }
            
            textField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
            textField.isEnabled = true
            break
        case VMemberDataEditBtnItem.VMemberDataEditBtnConfirm.rawValue:
                        
            if textField == self.nameTextField {
                self.currentNameEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
                self.editBtn_Name.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentNameEditStatus), for: .normal)
                checkNameInputData()
            }else if textField == self.telTextField {
                self.currentTelEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
                self.editBtn_Tel.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentTelEditStatus), for: .normal)
                checkTelInputData()
            }else if textField == self.mobilePhoneTextField {
                self.currentPhoneEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
                self.editBtn_Phone.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentPhoneEditStatus), for: .normal)
                checkMobilePhoneInputData()
            }else if textField == self.addressTextField {
                self.currentAddressEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
                self.editBtn_Address.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentAddressEditStatus), for: .normal)
                checkAddressInputData()
            }
            
            textField.setBottomBorder(with: lineColor, width: 0.0, bkColor: backgroundColor)
            textField.isEnabled = false
            break
        default:
            break
        }
    }
    
    // 檢查帳戶姓名輸入資料
    
    func checkNameInputData() {
        
        let name = self.nameTextField.text ?? ""
        if name == self.userName || name.count == 0 {
            
        }else {
            self.updateUserName(nameSt: name)
        }
    }
    
    // 檢查帳戶電話輸入資料
    
    func checkTelInputData() {
        let tel = self.telTextField.text ?? ""
        if tel == self.userTel || tel.count == 0 {
            
        }else{
            self.updateUserTel(telSt: tel)
        }
    }
    
    // 檢查帳戶生日輸入資料
    
    func checkBirthdayInputData() {
        let birthday = self.birthdayTextField.text ?? ""
        if birthday == NSLocalizedString("Member_Birthday_Placeholder_title", comment: "") || birthday.count == 0 {
            
        }else{
            self.updateUserBirthday(birthdaySt: birthday)
        }
    }
    
    // 檢查帳戶聯絡電話輸入資料
    
    func checkMobilePhoneInputData() {
        let phone = self.mobilePhoneTextField.text ?? ""
        if phone == self.userMobilePhone || phone.count == 0 {
            
        }else{
            self.updateUserMobilePhone(mobilePhoneSt: phone)
        }
    }
    
    // 檢查帳戶聯絡地址輸入資料
    
    func checkAddressInputData() {
        let address = self.addressTextField.text ?? ""
        if address == self.userAddress || address.count == 0 {
            
        }else{
            self.updateUserAddress(addressSt: address)
        }
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
                self.receiverTableView.reloadData()
                self.vaiv.stopProgressHUD(view: self.view)
            }
        }
    }
    
    // 刪除收件人資料
    
    func deleteReceiverData(ID:Int) {
        
        VClient.sharedInstance().VCDeleteReceiverByData(phone: self.accountPhone, delID: ID) { (_ isSuccess:Bool,_ message:String) in
            if isSuccess {
                
                DispatchQueue.main.async {
                    self.getReceiverData()
                }
                self.vaiv.stopProgressHUD(view: self.view)
                
            }else{
                self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
            }
        }
    }
    
    // MD5字串
    
    private func MD5_String(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
    
    
    //MARK: - Action
    
    @objc func leftBarBtnClick(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }

    @objc func editBtn_NameClick(_ sender:UIButton) {
        
        self.editBtnStatus(item: self.currentNameEditStatus, textField: self.nameTextField)
        
    }
    
    @objc func editBtn_TelClick(_ sender:UIButton) {
        
        self.editBtnStatus(item: self.currentTelEditStatus, textField: self.telTextField)
    }
    
    @objc func editBtn_PhoneClick(_ sender:UIButton) {
        
        self.editBtnStatus(item: self.currentPhoneEditStatus, textField: self.mobilePhoneTextField)
    }
    
    @objc func editBtn_AddressClick(_ sender:UIButton) {
        
        self.editBtnStatus(item: self.currentAddressEditStatus, textField: self.addressTextField)
    }
    
    @objc func setDateBtnClick(_ sender:CustomButton) {
        self.setDateBtn.inputView = self.datePickerContainer
        sender.becomeFirstResponder()
    }
    
    @objc func dateDoneBtnClick(_ sender:UIButton) {
        self.view.endEditing(true)
        
        if dateStaring.count != 0 {
            self.birthdayTextField.text = dateStaring
        }else{
            let todayDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateStaring = dateFormatter.string(from: todayDate)
            self.birthdayTextField.text = dateFormatter.string(from: todayDate)
        }
        
        let setAleartMessage:String = "\(NSLocalizedString("Member_Birthday_Set_Alert_title", comment: ""))\(self.dateStaring)"
        
        self.cavt = CustomAlertTwoBtnView(title: setAleartMessage, btn1Title: NSLocalizedString("Alert_Sure_title", comment: ""), btn2Title: NSLocalizedString("Member_Cancel_Btn_title", comment: ""), tag: 2, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.cavt.delegate = self
        self.view.addSubview(self.cavt)
      
    }

    
    @objc func cancelBtnClick(_ sender:UIButton) {
        self.view.endEditing(true)
    }
    
    @objc func dateChange(_ picker:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateStaring = dateFormatter.string(from: picker.date)
    }
    
    @objc func addBtn_RecipientClick(_ sender:UIButton) {
        
        print("111111")
        rav = RecipientAddView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        rav.delegate = self
        rav.accountPhone = self.accountPhone
        self.view.addSubview(rav)
    }

    @objc func closeBtnClick(_ sender:UIButton) {
        self.deleteTag = sender.tag
        self.cavt = CustomAlertTwoBtnView(title: NSLocalizedString("Member_Recipient_Delete_Alert_Text", comment: ""), btn1Title: NSLocalizedString("Member_Confirm_Btn_title", comment: ""), btn2Title: NSLocalizedString("Alert_Cancel_title", comment: ""), tag: 1, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.cavt.delegate = self
        self.view.addSubview(self.cavt)
    }
    
    @objc func biometricSwitchAction(_ sender:UISwitch) {
        var switchValue:Int = 0
        if sender.isOn == true {
            switchValue = 1
        }else{
            switchValue = 0
        }
        self.catf = CustomAlertTextFiledView(title: NSLocalizedString("Member_Input_Login_Pw_Alert_Text", comment: ""), btn1Title: NSLocalizedString("Alert_Cancel_title", comment: ""), btn2Title: NSLocalizedString("Member_Confirm_Btn_title", comment: ""), tag: switchValue, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height),isSecureTextEntry: true)
        self.catf.delegate = self
        self.view.addSubview(self.catf)
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
        
        return self.receiverIDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReceiverTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverTableViewCell
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let selectBkView = UIView()
        selectBkView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBkView
        
        let name = self.receiverNameArray[indexPath.row]
        let phone = self.receiverPhoneArray[indexPath.row]
        let city = self.receiverCityArray[indexPath.row]
        let town = self.receiverDistrictArray[indexPath.row]
        let address = self.receiverAddressArray[indexPath.row]
        let composeAddress = "\(city)\(town)\(address)"
        
        cell.loadData(nameSt: name, phoneSt: phone, addressSt: composeAddress)
        
        cell.closeBtn.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        cell.closeBtn.tag = self.receiverIDArray[indexPath.row]
        
        return cell
    }
    
    
    //MARK: - RecipientAddViewDelegate
    
    func addRecipientMessage(text: String) {
        rav.removeFromSuperview()
    
        self.cav = CustomAlertView.init(title: text, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 1, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.cav.delegate = self
        self.view.addSubview(self.cav)
    }
    
    func cancelBtnClick() {
        rav.removeFromSuperview()
    }
    
    //MARK: - CustomAlertViewDelegate
    
    func alertBtnClick(btnTag: Int) {
        
        if btnTag == 1 {
            self.cav.removeFromSuperview()
            self.getReceiverData()
        }else{
            self.cav.removeFromSuperview()
        }
    }
    
    //MARK: - CustomAlertTwoBtnViewDelegate
    
    func alertBtn1Click(btnTag: Int) {
        
        if btnTag == 1 {
            self.cavt.removeFromSuperview()
            self.deleteReceiverData(ID: self.deleteTag)
        }else if btnTag == 2 {
            self.cavt.removeFromSuperview()
            self.checkBirthdayInputData()
        }
    }
    
    func alertBtn2Click(btnTag: Int) {
        
        if btnTag == 1 {
            self.cavt.removeFromSuperview()
        }else if btnTag == 2 {
            self.cavt.removeFromSuperview()
            self.birthdayTextField.text = NSLocalizedString("Member_Birthday_Placeholder_title", comment: "")
        }else if btnTag == 3 {
            self.cavt.removeFromSuperview()
            self.biometricSwitch.setOn(false, animated: true)
        }
    }
    
    //MARK: - CustomAlertTextFiledViewDelegate
    
    func alertTextFiledBtn1Click(btnTag: Int) {
        let currentSwitchValue:Bool = UserDefaults.standard.bool(forKey: "C1")
        self.biometricSwitch.setOn(currentSwitchValue, animated: true)
        self.catf.removeFromSuperview()
    }
    
    func alertTextFiledBtn2Click(btnTag: Int, inputText: String) {
        let registerTimeArray = self.userRegisterTime.split(separator: ".")
        let resgisterTime = String(registerTimeArray[0])
        let passWord:String = "\(inputText)\(resgisterTime)"
        // 驗證登入密碼
        VClient.sharedInstance().VCLoginByPhone(account: accountPhone, pw: passWord) { (_ isSuccess:Bool,_ messageSt:String) in
            if isSuccess {
                print("--\(messageSt)--")
                self.catf.removeFromSuperview()
                self.vaiv.stopProgressHUD(view: self.view)
                let localAuthContext = LAContext()
                var authError: NSError?
                
                if localAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                    
                    if btnTag == 0 {
                        UserDefaults.standard.set(false, forKey: "C1")
                        self.biometricSwitch.setOn(false, animated: true)
                        do {
                            try KeychainPasswordItem.deleteCredentials(server: KeychainConfiguration.serviceName)
                            print("Deleted key success")
                        } catch {
                            if let error = error as? KeychainPasswordItem.KeychainError {
                                print(error.localizedDescription)
                            }
                        }
                    }else {
                        UserDefaults.standard.set(true, forKey: "C1")
                        self.biometricSwitch.setOn(true, animated: true)
                        let credentials = Credentials(username: self.accountPhone, password: inputText)
                        do {
                            try KeychainPasswordItem.addCredentials(credentials, server: KeychainConfiguration.serviceName)
                            print("Add keychain success")
                        } catch {
                            if let error = error as? KeychainPasswordItem.KeychainError {
                                print(error)
                                print("Keychain error: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                }else{
                    self.biometricSwitch.setOn(false, animated: true)
                    self.cav = CustomAlertView.init(title: NSLocalizedString("Member_Biometric_Not_Supported_Disabled", comment: ""), btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 3, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    self.cav.delegate = self
                    self.view.addSubview(self.cav)
                }
                
            }else{
                let currentSwitchValue:Bool = UserDefaults.standard.bool(forKey: "C1")
                self.biometricSwitch.setOn(currentSwitchValue, animated: true)
                self.catf.removeFromSuperview()
                self.vaiv.stopProgressHUD(view: self.view)
                self.cav = CustomAlertView.init(title: NSLocalizedString("Member_Input_Pw_Error_Alert_Text", comment: ""), btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 3, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.cav.delegate = self
                self.view.addSubview(self.cav)
                
            }
        }
    }

}
