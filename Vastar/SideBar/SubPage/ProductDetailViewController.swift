//
//  ProductDetailViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/21.
//

import UIKit

class ProductDetailViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet var productPhoto: UIImageView!
    
    @IBOutlet var productTitleLabel: UILabel!
    @IBOutlet var productModelLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!
    
    @IBOutlet var colorTitleLabel: UILabel!
    @IBOutlet var colorTextField: UITextField!
    
    @IBOutlet var voltageTitleLabel: UILabel!
    @IBOutlet var voltageTextField: UITextField!
    
    @IBOutlet var amountTitleLabel: UILabel!
    @IBOutlet var amountTextField: UITextField!
    
    @IBOutlet var addShoppingCarBtn: UIButton!
    
    @IBOutlet var contentTextView: UITextView!
    
    private var vaiv = VActivityIndicatorView()
    
    private var productCodeArray:Array<String> = []
    private var productNoArray:Array<String> = []
    private var productNameArray:Array<String> = []
    private var productPriceArray:Array<Int> = []
    private var productVoltageArray:Array<String> = []
    private var productColorArray:Array<String> = []
    private var productImageUrlArray:Array<String> = []
    private var productContentArray:Array<String> = []
    
    private var voltagePickerContainer = UIView()
    private var voltagePickerView = UIPickerView()
    
    private var colorPickerContainer = UIView()
    private var colorPickerView = UIPickerView()
    
    private var voltageDataArray:Array<String> = []
    private var colorDataArray:Array<String> = []
    
    private var selectVoltageSt:String = ""
    private var selectColorSt:String = ""
    
    private var responesProductDataArray:Array<Array<Any>> = []
    
    var groupID:Int = 0
    
    //MARK: - Life Cycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInterface()
        createVoltagePickerView()
        createColorPickerView()
        getProductDetailData()
        
        initializeInputView()
    }
    
    //MARK: - UI Interface Methods

    func setInterface() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 61.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        self.productTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.productModelLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.productPriceLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.colorTitleLabel.text = NSLocalizedString("Product_Detail_Color_title", comment: "")
        self.colorTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.voltageTitleLabel.text = NSLocalizedString("Product_Detail_Voltage_title", comment: "")
        self.voltageTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.amountTitleLabel.text = NSLocalizedString("Product_Detail_Amount_title", comment: "")
        self.amountTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.addShoppingCarBtn.setTitle(NSLocalizedString("Product_Detail_Add_ShoppingCar_title", comment: ""), for: .normal)
        self.addShoppingCarBtn.setTitleColor(UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0), for: .normal)
        
        self.contentTextView.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        self.contentTextView.isEditable = false
        
        self.voltageTextField.inputAccessoryView = UIView()
        
        self.colorTextField.inputAccessoryView = UIView()
        
    }
    
    
    func createVoltagePickerView() {
        let size = UIScreen.main.bounds
        self.voltagePickerContainer = UIView(frame: CGRect(x: 0, y: size.size.height - 150, width: size.size.width, height: 250))
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.size.width, height: 20))
        pickerToolBar.barStyle = .default
        pickerToolBar.sizeToFit()
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(title: NSLocalizedString("Member_Select_Btn_title", comment: ""), style: .done, target: self, action: #selector(voltageDoneBtnClick(_:)))

        pickerToolBar.items = [leftBarButton,rightBarButton]
        self.voltagePickerContainer.addSubview(pickerToolBar)
        
        self.voltagePickerView = UIPickerView(frame: CGRect(x: 0, y: pickerToolBar.frame.size.height, width: size.size.width, height: self.voltagePickerContainer.frame.size.height - pickerToolBar.frame.size.height))
        self.voltagePickerView.dataSource = self
        self.voltagePickerView.delegate = self
        
        self.voltagePickerContainer.addSubview(self.voltagePickerView)
        self.view.addSubview(self.voltagePickerContainer)
    }
    
    func createColorPickerView() {
        let size = UIScreen.main.bounds
        self.colorPickerContainer = UIView(frame: CGRect(x: 0, y: size.size.height - 150, width: size.size.width, height: 250))
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.size.width, height: 20))
        pickerToolBar.barStyle = .default
        pickerToolBar.sizeToFit()
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem(title: NSLocalizedString("Member_Select_Btn_title", comment: ""), style: .done, target: self, action: #selector(colorDoneBtnClick(_:)))

        pickerToolBar.items = [leftBarButton,rightBarButton]
        self.colorPickerContainer.addSubview(pickerToolBar)
        
        self.colorPickerView = UIPickerView(frame: CGRect(x: 0, y: pickerToolBar.frame.size.height, width: size.size.width, height: self.colorPickerContainer.frame.size.height - pickerToolBar.frame.size.height))
        self.colorPickerView.dataSource = self
        self.colorPickerView.delegate = self
        
        self.colorPickerContainer.addSubview(self.colorPickerView)
        self.view.addSubview(self.colorPickerContainer)
    }
    
    
    func initializeInputView() {
        
        self.voltageTextField.inputView = self.voltagePickerContainer
        self.voltagePickerContainer.removeFromSuperview()
        
        self.colorTextField.inputView = self.colorPickerContainer
        self.colorPickerContainer.removeFromSuperview()
    }

    
    //MARK: - Assistant Methods
    
    func getProductDetailData() {
        
        self.productCodeArray.removeAll()
        self.productNoArray.removeAll()
        self.productNameArray.removeAll()
        self.productPriceArray.removeAll()
        self.productVoltageArray.removeAll()
        self.productColorArray.removeAll()
        self.productImageUrlArray.removeAll()
        self.productContentArray.removeAll()
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCGGetProductGroupData(gID: groupID) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            
            if isSuccess {
                if resDataArray.count != 0 {
                    
                    self.responesProductDataArray = resDataArray
                    let volatgeArray = resDataArray[4] as? Array<String> ?? []
                    let colorArray = resDataArray[5] as? Array<String> ?? []
                    
                    let set_Volatge = Set(volatgeArray)
                    let set_VolatgeArray = Array(set_Volatge.sorted(by: <))
                    
                    let set_Color = Set(colorArray)
                    let set_ColorArray = Array(set_Color)
                    
                    print("=== \(set_Volatge.sorted(by: <)) == \(set_ColorArray)")
                    
                    self.voltageDataArray = set_VolatgeArray
                    self.colorDataArray = set_ColorArray
                    
                    self.voltagePickerView.reloadComponent(0)
                    self.colorPickerView.reloadComponent(0)
                    
                    let default_Voltage:String = set_VolatgeArray[0]
                    let default_Color:String = set_ColorArray[0]
                    
                    self.voltageTextField.text = default_Voltage
                    self.colorTextField.text = default_Color
                    
                    self.defaultLoadProductDetailData(voltageSt: default_Voltage, colorSt: default_Color, responesDataArray: resDataArray)
                }else{
                    self.vaiv.stopProgressHUD(view: self.view)
                }
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            }
        }
    }
    
    func processProductGroupData(v:String,colorSt:String,resDataArray:Array<Array<Any>>) -> [String:Array<Any>] {
        
        let codeArray = resDataArray[0] as? Array<String> ?? []
        let NoArray = resDataArray[1] as? Array<String> ?? []
        let nameArray = resDataArray[2] as? Array<String> ?? []
        let priceArray = resDataArray[3] as? Array<Int> ?? []
        let voltageArray = resDataArray[4] as? Array<String> ?? []
        let colorArray = resDataArray[5] as? Array<String> ?? []
        let imageUrlArray = resDataArray[6] as? Array<String> ?? []
        let contentArray = resDataArray[7] as? Array<String> ?? []
        
        var dataDict:[String:Array<Any>] = [:]
        var dataArray:Array<Any> = []
        
        var pCodeArray:Array<String> = []
        var pNoArray:Array<String> = []
        var pNameArray:Array<String> = []
        var pPriceArray:Array<Int> = []
        var pVoltageArray:Array<String> = []
        var pColorArray:Array<String> = []
        var pImageUrlArray:Array<String> = []
        var pContentArray:Array<String> = []
        
        for i in 0 ..< codeArray.count {
            
            let code:String = codeArray[i]
            let No:String = NoArray[i]
            let name:String = nameArray[i]
            let price:Int = priceArray[i]
            let voltage:String = voltageArray[i]
            let color:String = colorArray[i]
            let imageUrl:String = imageUrlArray[i]
            let content:String = contentArray[i]
            
            if v == voltage && color == colorSt {
                pCodeArray.append(code)
                pNoArray.append(No)
                pNameArray.append(name)
                pPriceArray.append(price)
                pVoltageArray.append(voltage)
                pColorArray.append(color)
                pImageUrlArray.append(imageUrl)
                pContentArray.append(content)
                
                dataArray = [code,No,name,price,voltage,color,imageUrl,content]
            }
        }
        
        let keySt = "\(v),\(colorSt)"
        dataDict.updateValue(dataArray, forKey: keySt)
        return dataDict
        
    }
    
    
    func defaultLoadProductDetailData(voltageSt:String,colorSt:String,responesDataArray:Array<Array<Any>>) {
        
        let dict = self.processProductGroupData(v: voltageSt, colorSt: colorSt, resDataArray: responesDataArray)
        let key:String = "\(voltageSt),\(colorSt)"
        let dictValue:Array<Any> = dict[key] ?? []
        if dictValue.count != 0 {
            
            let code:String = dictValue[0] as? String ?? ""
            let No:String = dictValue[1] as? String ?? ""
            let name:String = dictValue[2] as? String ?? ""
            let price:Int = dictValue[3] as? Int ?? 0
            let voltage:String = dictValue[4] as? String ?? ""
            let color:String = dictValue[5] as? String ?? ""
            let imageUrl:String = dictValue[6] as? String ?? ""
            let content:String = dictValue[7] as? String ?? ""
            
            self.navigationItem.title = name
            self.productTitleLabel.text = name
            self.productModelLabel.text = code
            self.productPriceLabel.text = "$\(String(price))"
            self.contentTextView.text = content
            
            let url = URL.init(string: imageUrl)
            if url != nil {
                let imageData = try? Data(contentsOf: url!)
                let defaultData = UIImage(named: "logo_item")!.pngData()
                self.productPhoto.image = UIImage(data: imageData ?? defaultData!)
            }else{
                let defaultData = UIImage(named: "logo_item")!.pngData()
                self.productPhoto.image = UIImage(data: defaultData!)
            }
            self.vaiv.stopProgressHUD(view: self.view)
            
        }else{
            self.vaiv.stopProgressHUD(view: self.view)
            VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Product_Detail_Aleart_title", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {
                self.voltageTextField.text = voltageSt
                self.colorTextField.text = colorSt
            }
        }

    }
    
    func selectLoadProductDetailData(voltageSt:String,colorSt:String,responesDataArray:Array<Array<Any>>) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let dict = self.processProductGroupData(v: voltageSt, colorSt: colorSt, resDataArray: responesDataArray)
            let key:String = "\(voltageSt),\(colorSt)"
            let dictValue:Array<Any> = dict[key] ?? []
            if dictValue.count != 0 {
                let code:String = dictValue[0] as? String ?? ""
                let No:String = dictValue[1] as? String ?? ""
                let name:String = dictValue[2] as? String ?? ""
                let price:Int = dictValue[3] as? Int ?? 0
                let voltage:String = dictValue[4] as? String ?? ""
                let color:String = dictValue[5] as? String ?? ""
                let imageUrl:String = dictValue[6] as? String ?? ""
                let content:String = dictValue[7] as? String ?? ""
                
                var photo:UIImage?
                let url = URL.init(string: imageUrl)
                if url != nil {
                    let imageData = try? Data(contentsOf: url!)
                    let defaultData = UIImage(named: "logo_item")!.pngData()
                    photo = UIImage(data: imageData ?? defaultData!)
                }else{
                    let defaultData = UIImage(named: "logo_item")!.pngData()
                    photo = UIImage(data: defaultData!)
                }
                
                DispatchQueue.main.async {
                    
                    self.navigationItem.title = name
                    self.productTitleLabel.text = name
                    self.productModelLabel.text = code
                    self.productPriceLabel.text = "$\(String(price))"
                    self.contentTextView.text = content
                    self.productPhoto.image = photo
                    self.vaiv.stopProgressHUD(view: self.view)
                }
            }else{
                DispatchQueue.main.async {
                    self.vaiv.stopProgressHUD(view: self.view)
                    VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("Product_Detail_Aleart_title", comment: ""), actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
                }
            }
        }
    }
    
    func GetColorPickerViewSelect() {
        let component = self.colorPickerView.selectedRow(inComponent: 0)
        if self.colorDataArray.count != 0 {
            self.selectColorSt = self.colorDataArray[component]
            self.colorTextField.text = self.selectColorSt
            let voltage:String = self.voltageTextField.text ?? ""
            
            self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
            self.selectLoadProductDetailData(voltageSt: voltage, colorSt: self.selectColorSt, responesDataArray: self.responesProductDataArray)
            
        }
    }
    
    func GetVoltagePickerViewSelect() {
        let component = self.voltagePickerView.selectedRow(inComponent: 0)
        if self.voltageDataArray.count != 0 {
            self.selectVoltageSt = self.voltageDataArray[component]
            self.voltageTextField.text = self.selectVoltageSt
            let color:String = self.colorTextField.text ?? ""
            
            self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
            self.selectLoadProductDetailData(voltageSt: self.selectVoltageSt, colorSt: color, responesDataArray: self.responesProductDataArray)
        }
    }
    
    
    //MARK: - Action
    
    @objc func voltageDoneBtnClick(_ sender:UIButton) {
        self.view.endEditing(true)
        self.GetVoltagePickerViewSelect()
    }
    
    
    @objc func colorDoneBtnClick(_ sender:UIButton) {
        self.view.endEditing(true)
        self.GetColorPickerViewSelect()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var result:Int = 0
        
        switch component {
        case 0:
            if pickerView == self.voltagePickerView {
                result = self.voltageDataArray.count
            }else if pickerView == self.colorPickerView {
                result = self.colorDataArray.count
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
            
            if pickerView == self.voltagePickerView {
                title =  self.voltageDataArray[row]
            }else if pickerView == self.colorPickerView {
                title = self.colorDataArray[row]
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
