//
//  RecipientAddView.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/10.
//

import UIKit

protocol RecipientAddViewDelegate {
    func addRecipientMessage(text:String)
    func cancelBtnClick()
}

class RecipientAddView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var nameTitleLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nameWarningLabel: UILabel!
    
    @IBOutlet var phoneTitleLabel: UILabel!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var phoneWarningLabel: UILabel!
    
    @IBOutlet var addressTitleLabel: UILabel!
    @IBOutlet var addressWarningLabel: UILabel!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var townTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var addBtn: UIButton!
    
    var delegate:RecipientAddViewDelegate?
    var accountPhone:String = ""
    
    private var vaiv = VActivityIndicatorView()
    
    private var cityPickerContainer = UIView()
    private var cityPickerView = UIPickerView()
    
    private var townPickerContainer = UIView()
    private var townPickerView = UIPickerView()
    
    private var cityDataArray:Array<String> = []
    private var townDataArray:Array<String> = []
    
    private var selectCitySt:String = ""
    private var selectTownSt:String = ""
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadXib()
        setInterface()
        createCityPickerView()
        createTownPickerView()
        initializeInputView()
        getCityData()
    }
    
    init(title:String,aConditionType:Int,frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Interface Methods
    
    func loadXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RecipientAddView", bundle: bundle)
        ///透過nib來取得xibView
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(xibView)
        
        ///設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    func setInterface() {
        
        let bkColor:UIColor = UIColor.init(red: 0.0/255.0, green: 62.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        let placeHolderTextColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let textColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let lineColor:UIColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let font:UIFont = UIFont.systemFont(ofSize: 16.0)
        
        self.nameTitleLabel.text = NSLocalizedString("Member_Recipient_Name_title", comment: "")
        self.nameTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.nameWarningLabel.text = NSLocalizedString("Member_Recipient_Name_Alert_Text", comment: "")
        self.nameWarningLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        self.nameWarningLabel.isHidden = true
        self.nameTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: bkColor)
        self.nameTextField.setTextColor(textColor, font: font)
        
        self.phoneTitleLabel.text = NSLocalizedString("Member_Recipient_Phone_title", comment: "")
        self.phoneTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.phoneWarningLabel.text = NSLocalizedString("Member_Recipient_Phone_Alert_Text", comment: "")
        self.phoneWarningLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        self.phoneWarningLabel.isHidden = true
        
        self.phoneTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: bkColor)
        self.phoneTextField.setTextColor(textColor, font: font)
        
        self.cityTextField.inputAccessoryView = UIView()
        self.cityTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: bkColor)
        self.cityTextField.setTextColor(textColor, font: font)
        self.cityTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Member_Recipient_Adress_City_title", comment: ""), colour: placeHolderTextColor, font: font)
        
        self.townTextField.inputAccessoryView = UIView()
        self.townTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: bkColor)
        self.townTextField.setTextColor(textColor, font: font)
        self.townTextField.setPlaceHolderAttributes(placeHolderText: NSLocalizedString("Member_Recipient_Adress_Town_title", comment: ""), colour: placeHolderTextColor, font: font)
        
        self.addressTitleLabel.text = NSLocalizedString("Member_Recipient_Adress_title", comment: "")
        self.addressTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.addressTextField.placeholder = NSLocalizedString("Member_Recipient_Adress_Placeholder_title", comment: "")
        self.addressTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(addressTextFieldClick(_:)))
        self.addressWarningLabel.text = NSLocalizedString("Member_Recipient_Address_Alert_Text", comment: "")
        self.addressWarningLabel.textColor = UIColor.init(red: 213.0/255.0, green: 92.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        self.addressWarningLabel.isHidden = true
        
        self.addressTextField.setBottomBorder(with: lineColor, width: 1.0, bkColor: bkColor)
        self.addressTextField.setTextColor(textColor, font: font)
        
        self.addBtn.setTitle(NSLocalizedString("Member_Add_Btn_title", comment: ""), for: .normal)
        self.addBtn.addTarget(self, action: #selector(addBtnClick(_:)), for: .touchUpInside)
        self.addBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        
        self.cancelBtn.setTitle(NSLocalizedString("Member_Cancel_Btn_title", comment: ""), for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        self.cancelBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
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
        self.addSubview(self.cityPickerContainer)
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
        self.addSubview(self.townPickerContainer)
    }
    
    
    
    func initializeInputView() {
        
        self.cityTextField.inputView = self.cityPickerContainer
        self.cityPickerContainer.removeFromSuperview()
        
        self.townTextField.inputView = self.townPickerContainer
        self.townPickerContainer.removeFromSuperview()
    }
    
    
    //MARK:- Assistant Methods
    
    func getCityData() {
        VClient.sharedInstance().VCGetCityData { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<String>) in
            
            if isSuccess {
                self.cityDataArray = resDataArray
//                print("\(self.cityDataArray)")
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
    
    func addReceiver(nameSt:String,phoneSt:String,citySt:String,townSt:String,addressSt:String) {
        
        self.vaiv.startProgressHUD(view: self, content: NSLocalizedString("", comment: ""))
        let dataArray:Array<String> = [self.accountPhone,nameSt,phoneSt,citySt,townSt,addressSt]
        VClient.sharedInstance().VCAddReceiverByData(bodyArray: dataArray) { (_ isSuccess:Bool,_ message:String) in
            
            if isSuccess {
                print(">\(message)<")
                self.vaiv.stopProgressHUD(view: self)
                self.delegate?.addRecipientMessage(text: message)
                
            }else{
                print(">\(message)<")
                self.vaiv.stopProgressHUD(view: self)
                self.delegate?.addRecipientMessage(text: message)
            }
        }
    }
    
    func checkInputData() {
        
        let nameText = self.nameTextField.text ?? ""
        let phoneText = self.phoneTextField.text ?? ""
        let cityText = self.cityTextField.text ?? ""
        let townText = self.townTextField.text ?? ""
        let addressText = self.addressTextField.text ?? ""
        
        if nameText.count == 0 {
            self.nameWarningLabel.isHidden = false
        }else{
            self.nameWarningLabel.isHidden = true
        }
        if phoneText.count == 0 {
            self.phoneWarningLabel.isHidden = false
        }else{
            self.phoneWarningLabel.isHidden = true
        }
        if cityText.count == 0 {
            self.addressWarningLabel.isHidden = false
        }else{
            self.addressWarningLabel.isHidden = true
        }
        if townText.count == 0 {
            self.addressWarningLabel.isHidden = false
        }else{
            self.addressWarningLabel.isHidden = true
        }
        if addressText.count == 0 {
            self.addressWarningLabel.isHidden = false
        }else{
            self.addressWarningLabel.isHidden = true
        }
        
        if nameText.count != 0 && phoneText.count != 0 && cityText.count != 0 && townText.count != 0 && addressText.count != 0 {
            self.nameWarningLabel.isHidden = true
            self.phoneWarningLabel.isHidden = true
            self.addressWarningLabel.isHidden = true
            
            self.addReceiver(nameSt: nameText, phoneSt: phoneText, citySt: cityText, townSt: townText, addressSt: addressText)
        }
    }
    
    //MARK:- Action
    
    @objc func addBtnClick(_ sender:UIButton) {

        checkInputData()
    }
    
    @objc func cancelBtnClick(_ sender:UIButton) {
        
        self.delegate?.cancelBtnClick()
    }
    
    @objc func cityDoneBtnClick(_ sender:UIButton) {
        self.endEditing(true)
        self.GetCityPickerViewSelect()
        self.townTextField.text = ""
    }
    
    @objc func townDoneBtnClick(_ sender:UIButton) {
        self.endEditing(true)
        self.GetTownPickerViewSelect()
    }
    
    @objc func addressTextFieldClick(_ sender:UIButton) {
        
    }
    
    //MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var result:Int = 0
        
        switch component {
        case 0:
            if pickerView == self.cityPickerView {
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
            
            if pickerView == self.cityPickerView {
                title =  self.cityDataArray[row]
            }else if pickerView == self.townPickerView {
                let town:String = self.townDataArray[row]
                title = town
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
