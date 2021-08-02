//
//  MemberDataViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import UIKit

class MemberDataViewController: UIViewController,RecipientAddViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var birthdayTextField: UITextField!
    
    @IBOutlet var telLabel: UILabel!
    @IBOutlet var telTextField: UITextField!
    
    @IBOutlet var editBtn_Name: UIButton!
    @IBOutlet var setDateBtn: CustomButton!
    @IBOutlet var editBtn_Tel: UIButton!
    
    @IBOutlet var recipientLabel: UILabel!
    @IBOutlet var addBtn_Recipient: UIButton!
    
    @IBOutlet var receiverTableView: UITableView!
    @IBOutlet var viewContainer: UIView!
    
    private var datePickerContainer = UIView()
    private var datePickerView = UIDatePicker()
    
    private var userName:String = ""
    private var userBirthday:String = ""
    private var userTel:String = ""
    
    private var currentNameEditStatus:Int = -1
    private var currentTelEditStatus:Int = -1
    
    private var dateStaring:String = ""

    private var vaiv = VActivityIndicatorView()
    private var rav = RecipientAddView()
    
    private var receiverIDArray:Array<Int> = []
    private var receiverNameArray:Array<String> = []
    private var receiverPhoneArray:Array<String> = []
    private var receiverCityArray:Array<String> = []
    private var receiverDistrictArray:Array<String> = []
    private var receiverAddressArray:Array<String> = []
    
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
        
        self.currentNameEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
        self.currentTelEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
        
        self.editBtn_Name.setTitle(NSLocalizedString("Member_Edit_Btn_title", comment: ""), for: .normal)
        self.editBtn_Name.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.editBtn_Name.addTarget(self, action: #selector(editBtn_NameClick(_:)), for: .touchUpInside)
        
        self.setDateBtn.setTitle(NSLocalizedString("Member_Set_Date_Btn_title", comment: ""), for: .normal)
        self.setDateBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.setDateBtn.addTarget(self, action: #selector(setDateBtnClick(_:)), for: .touchUpInside)
        
        self.editBtn_Tel.setTitle(NSLocalizedString("Member_Edit_Btn_title", comment: ""), for: .normal)
        self.editBtn_Tel.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.editBtn_Tel.addTarget(self, action: #selector(editBtn_TelClick(_:)), for: .touchUpInside)
        
        
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
    
    
    //MARK:- Assistant Methods
    
    // 取得帳號資料
    
    func getUserInfo(accountName:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        
        VClient.sharedInstance().VCGetUserInfoByPhone(phone: accountName) { (_ isSuccess:Bool,_ message:String,_ isResult:Int,_ dictResData:[String:Any]) in
            
            if isSuccess {
                
                let name = dictResData["Name"] as? String ?? ""
                let birthday = dictResData["Birthday"] as? String ?? ""
                let tel = dictResData["Telephone"] as? String ?? ""
                self.userName = name
                self.userBirthday = birthday
                self.userTel = tel
                self.showUserInfo(nameSt: name, birthdaySt: birthday, telSt: tel)
                
                self.vaiv.stopProgressHUD(view: self.view)
                
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                    
                }
            }
        }
    }
    
    // 帳戶資料顯示設定
    
    func showUserInfo(nameSt:String,birthdaySt:String,telSt:String) {
        
        self.nameTextField.text = nameSt
        
        if birthdaySt.count == 0 {
            self.setDateBtn.isHidden = false
            self.birthdayTextField.text = NSLocalizedString("Member_Birthday_Placeholder_title", comment: "")
        }else{
            self.setDateBtn.isHidden = true
            self.birthdayTextField.text = birthdaySt
        }
        self.telTextField.text = telSt
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
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
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
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
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
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
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
            }else{
                self.currentTelEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnConfirm.rawValue
                self.editBtn_Tel.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentTelEditStatus), for: .normal)
            }
            
            textField.setBottomBorder(with: lineColor, width: 1.0, bkColor: backgroundColor)
            textField.isEnabled = true
            break
        case VMemberDataEditBtnItem.VMemberDataEditBtnConfirm.rawValue:
                        
            if textField == self.nameTextField {
                self.currentNameEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
                self.editBtn_Name.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentNameEditStatus), for: .normal)
                checkNameInputData()
            }else{
                self.currentTelEditStatus = VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue
                self.editBtn_Tel.setTitle(AppInfo.GetMemberDataEditBtnTitle(item: self.currentTelEditStatus), for: .normal)
                checkTelInputData()
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
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            }
        }
    }
    
    
    //MARK:- Action
    
    @objc func leftBarBtnClick(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }

    @objc func editBtn_NameClick(_ sender:UIButton) {
        
        self.editBtnStatus(item: self.currentNameEditStatus, textField: self.nameTextField)
        
    }
    
    @objc func editBtn_TelClick(_ sender:UIButton) {
        
        self.editBtnStatus(item: self.currentTelEditStatus, textField: self.telTextField)
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
        VAlertView.presentAlertMultipleAction(title: NSLocalizedString("Alert_title", comment: ""), message: setAleartMessage, actionTitle: [NSLocalizedString("Alert_Sure_title", comment: ""),NSLocalizedString("Member_Cancel_Btn_title", comment: "")], preferredStyle: .alert, viewController: self) { (btnIndex, btnTitle) in
            if btnIndex == 1 {
                
                self.checkBirthdayInputData()
                
            }else if btnIndex == 2 {
                self.birthdayTextField.text = NSLocalizedString("Member_Birthday_Placeholder_title", comment: "")
            }
        }
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
        VAlertView.presentAlert(title: NSLocalizedString("Member_Recipient_Delete_Alert_Text", comment: ""), message: "", actionTitle: [NSLocalizedString("Member_Confirm_Btn_title", comment: "")], preferredStyle: .alert, viewController: self) { (_ buttonIndex:Int,_ buttonTitle:String) in
            if buttonIndex == 1 {
                self.deleteReceiverData(ID: sender.tag)
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
        
        return self.receiverIDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReceiverTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverTableViewCell
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
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
        
        VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: text, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
            self.getReceiverData()
        }
    }
    
    func cancelBtnClick() {
        rav.removeFromSuperview()
    }
    
}
