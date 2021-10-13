//
//  ShoppingCarViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import UIKit
import IQKeyboardManagerSwift

class ShoppingCarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ShoppingCarTableviewDelegate,CustomAlertViewDelegate {

    @IBOutlet var shoppingCarTableView: UITableView!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var checkoutBtn: UIButton!
    
    private var vaiv = VActivityIndicatorView()
    
    private var IDArray:Array<Int> = []
    private var NoArray:Array<String> = []
    private var titleArray:Array<String> = []
    private var colorArray:Array<String> = []
    private var amountArray:Array<Int> = []
    private var vArray:Array<String> = []
    private var priceArray:Array<Int> = []
    private var photoArray:Array<UIImage> = []
    
    private var tmpAmount:Int = 0
    private var cav = CustomAlertView()
    
    let userDefault = UserDefaults.standard

    var accountPhone:String = ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLeftBarButton()
        setInterface()
        setTableView()
        setupSWReveal()
        getShoppingCarData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let flag:Int = self.userDefault.object(forKey: "backDefault")as? Int ?? 0
        if flag == 1 {
            self.userDefault.set(0, forKey: "backDefault")
            let nav = UINavigationController()
            let reveal = self.revealViewController()
            let vc = ProductViewController(nibName: "ProductViewController", bundle: nil)
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
        self.navigationItem.title = NSLocalizedString("Shopping_title", comment: "")
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        self.countLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.checkoutBtn.setTitle(NSLocalizedString("Shopping_Checkout_Btn_title", comment: ""), for: .normal)
        self.checkoutBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.checkoutBtn.addTarget(self, action: #selector(checkoutBtnClick(_:)), for: .touchUpInside)
        
        
    }
    
    func setTableView() {
        
        self.shoppingCarTableView.delegate = self
        self.shoppingCarTableView.dataSource = self
        self.shoppingCarTableView.separatorStyle = .none
        
        self.shoppingCarTableView.register(UINib(nibName: "shoppingCarTableViewCell", bundle: nil), forCellReuseIdentifier: "shoppingCell")
        self.shoppingCarTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    func setupSWReveal(){
        //adding panGesture to reveal menu controller
        view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        //adding tap gesture to hide menu controller
        view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        //setting reveal width of menu controller manually
        self.revealViewController()?.rearViewRevealWidth = UIScreen.main.bounds.width * (2/3)
        
//        self.revealViewController()?.delegate = self
        
    }
    
    //MARK: - Assistant Methods
    
    // 取得購物車資料
    
    func getShoppingCarData() {
        
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
                    self.getSum()
                    self.shoppingCarTableView.reloadData()
                }else{
                    
                    VClient.sharedInstance().VCDeleteAllShoppingCarData { isDone in
                        if isDone {
                            self.getSum()
                            self.shoppingCarTableView.reloadData()
                        }else{
                            self.getSum()
                            self.shoppingCarTableView.reloadData()
                        }
                    }
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
        }
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let countProductPriceSt:String = format.string(from: NSNumber(value:countProductPrice)) ?? ""

        self.countLabel.text = "共\(countProduct)件  共\(countProductPriceSt)元"
    }
    
    // 刪除購物車資料
    
    func deleteShoppingCarByID(titleSt:String,colorSt:String,vSt:String) {
        
        VClient.sharedInstance().VCDeleteShoppingCarDataByID(titleSt: titleSt, colorSt: colorSt, v: vSt) { (_ isDone:Bool) in
            
            if isDone {
                self.getShoppingCarData()
            }
        }
    }
    
    // 調整購物車數量
    
    func addShppingCarData(dataArray:Array<Any>) {
            
        let p_No = dataArray[0] as? String ?? ""
        let p_title = dataArray[1] as? String ?? ""
        let p_color = dataArray[2] as? String ?? ""
        let p_v = dataArray[3] as? String ?? ""
        let p_price = dataArray[4] as? Int ?? 0
        let p_amount = dataArray[5] as? Int ?? 0
        
        let image = dataArray[6] as? UIImage
        let defaultData = UIImage(named: "logo_item")!.pngData()
        let p_image = image?.pngData() ?? defaultData
        let imageData:NSData = p_image! as NSData
        
        let dataArray:Array<Any> = [p_No,p_title,p_color,p_v,p_amount,p_price,imageData]
        
        VClient.sharedInstance().VCAddShoppingCarData(dataArray: dataArray) { (_ isDone:Bool) in
            if isDone {
                self.getShoppingCarData()
            }
        }
    }
    
    
    
    //MARK: - Action
    
    @objc func leftBarBtnClick(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    @objc func closeBtnClick(_ sender:UIButton) {
        
        let index:Int = sender.tag
        self.deleteShoppingCarByID(titleSt: self.titleArray[index], colorSt: self.colorArray[index], vSt: self.vArray[index])
        print(">>>>>\(index) <<<<<<")
    }
    
    
    @objc func amountTextFieldClick(_ textField:UITextField) {
        
        
        let indexTag:Int = textField.tag
        
        let currentAmountText:String = textField.text ?? "0"
        let currentAmount:Int = Int(currentAmountText) ?? 0
        
        if currentAmount > self.tmpAmount {
            
            let num:Int = currentAmount - self.tmpAmount
            let dataArray:Array<Any> = [self.NoArray[indexTag],self.titleArray[indexTag],self.colorArray[indexTag],self.vArray[indexTag],self.priceArray[indexTag],num,self.photoArray[indexTag]]
            addShppingCarData(dataArray: dataArray)
            
        }else if currentAmount < self.tmpAmount {
            
            let num:Int = currentAmount - self.tmpAmount
            let dataArray:Array<Any> = [self.NoArray[indexTag],self.titleArray[indexTag],self.colorArray[indexTag],self.vArray[indexTag],self.priceArray[indexTag],num,self.photoArray[indexTag]]
            addShppingCarData(dataArray: dataArray)
            
        }else if currentAmount == self.tmpAmount {
            
        }
    }
    
    @objc func checkoutBtnClick(_ sender:UIButton) {
        if self.titleArray.count != 0 {
            let vc = CheckoutViewController(nibName: "CheckoutViewController", bundle: nil)
            vc.accountPhone = self.accountPhone
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.cav = CustomAlertView.init(title: NSLocalizedString("Shopping_Checkout_Alert_title", comment: ""), btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.cav.delegate = self
            self.view.addSubview(self.cav)
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
        
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:shoppingCarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath) as! shoppingCarTableViewCell
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
  
        let titleSt:String = "\(name)\n\(v),\(color)\n$\(countPriceSt)"
        cell.loadData(titleST: titleSt, amount: amount, photo: photo)
        
        cell.closeBtn.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        cell.closeBtn.tag = indexPath.row
        
        cell.amountAddBtn.tag = indexPath.row
        cell.amountLessBtn.tag = indexPath.row
        
        cell.amountTextField.tag = indexPath.row
        cell.amountTextField.delegate = self
        cell.amountTextField.keyboardToolbar.doneBarButton .setTarget(self, action: #selector(amountTextFieldClick(_:)))
        
        cell.delegate = self
        
        return cell
    }
    
    
    //MARK: - UITextFieldDelegate

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let text:String = textField.text ?? "0"
        self.tmpAmount = Int(text) ?? 0
        print("-----> \(self.tmpAmount)")
    }
    
    //MARK: - ShoppingCarTableviewDelegate
    
    // 購物車商品數量增加Click
    
    func amountAddBtnClick(index: Int) {
        
        let dataArray:Array<Any> = [self.NoArray[index],self.titleArray[index],self.colorArray[index],self.vArray[index],self.priceArray[index],1,self.photoArray[index]]
        addShppingCarData(dataArray: dataArray)
        
    }
    
    // 購物車商品數量減少Click
    
    func amountLessBtnClick(index: Int) {
        
        let dataArray:Array<Any> = [self.NoArray[index],self.titleArray[index],self.colorArray[index],self.vArray[index],self.priceArray[index],-1,self.photoArray[index]]
        addShppingCarData(dataArray: dataArray)
    }
    
    //MARK: - CustomAlertViewDelegate
    
    func alertBtnClick(btnTag: Int) {
        self.cav.removeFromSuperview()
    }
}
