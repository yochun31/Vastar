//
//  ProductListViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/15.
//

import UIKit
import SDWebImage
import BadgeHub

class ProductListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CustomAlertViewDelegate {
    
    
    @IBOutlet var productTableView: UITableView!
    
    private var vaiv = VActivityIndicatorView()
    
    private var productOrderArray:Array<Int> = []
    private var productGroupArray:Array<Int> = []
    private var productNameArray:Array<String> = []
    private var productImageUrlArray:Array<String> = []
    private var productImageDataArray:Array<Data> = []
    private var productTmpImageUrlArray:Array<URL> = []
    
    private var flag:Int = 0
    private var cav = CustomAlertView()
    private let userDefault = UserDefaults.standard
    
    private var rightNavBtn = UIButton()
    private var rightBarBtnItem = UIBarButtonItem()
    private var bHub:BadgeHub?
    private var IDArray:Array<Int> = []
    
//    private var bHub:BadgeHub?
    
    let AppInfo = AppInfoManager()
    var productItemID:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setTableView()
        setNavBarBtn()
        setProductTableData(item: productItemID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GetShoppingCarDataCount()
    }
    
    //MARK: - UI Interface Methods
    
    // 設定UI介面
    
    func setTableView() {
        
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        
        self.productTableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProdectCell")
        self.productTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    // 設定Navigation右側按鈕
    
    func setNavBarBtn() {
        
        self.rightNavBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.rightNavBtn.setImage(UIImage(named: "shoppingcart"), for: .normal)
        self.rightNavBtn.addTarget(self, action: #selector(rightBtnClick(_:)), for: .touchUpInside)
        
        self.rightBarBtnItem = UIBarButtonItem.init(customView: self.rightNavBtn)
        self.navigationItem.rightBarButtonItem = self.rightBarBtnItem
        self.bHub = BadgeHub(barButtonItem: self.rightBarBtnItem)
        self.bHub?.setCount(self.IDArray.count)
        self.bHub?.moveCircleBy(x: 0, y: 5)
        self.bHub?.scaleCircleSize(by: 0.8)
        
    }
    
    //MARK: - Assistant Methods

    // 判斷商品資料讀取
    
    func setProductTableData(item:Int) {
        let type:String = AppInfo.GetProductItemTitle(item: item)
        
        
        if item == VProductItem.VProductAll.rawValue {
            self.getAllProductData()
        }else{
            self.getProductDataByType(typeSt: type)
        }
    }
    
    // 取得所有商品資料
    
    func getAllProductData() {
        
        self.productOrderArray.removeAll()
        self.productGroupArray.removeAll()
        self.productNameArray.removeAll()
        self.productImageUrlArray.removeAll()
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCGetAllProductData { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            
            if isSuccess {
                if resDataArray.count != 0 {
                    
                    let groupIDArray = resDataArray[1] as? Array<Int> ?? []
                    let set = Set(groupIDArray)
                    let setArray = Array(set.sorted(by: <))
                    print("\(self.productGroupArray) === \(set.sorted(by: <))")
                    
                    for i in 0 ..< setArray.count {
                        let dict = self.processProductData(gID: setArray[i], resDataArray: resDataArray)
                        let array = dict[setArray[i]] ?? []
                        let order_Array = array[0] as? Array<Int> ?? []
                        let groupID_Array = array[1] as? Array<Int> ?? []
                        let name_Array = array[2] as? Array<String> ?? []
                        let imageUrl_Array = array[3] as? Array<String> ?? []
                        
                        self.productOrderArray.append(order_Array[0])
                        self.productGroupArray.append(groupID_Array[0])
                        self.productNameArray.append(name_Array[0])
                        self.productImageUrlArray.append(imageUrl_Array[0])
                    }
                    self.defaultDownloadImage()
                }else{

                    self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    self.cav.delegate = self
                    self.view.addSubview(self.cav)
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
    
    // 取得商品分類資料
    
    func getProductDataByType(typeSt:String) {
        
        self.productOrderArray.removeAll()
        self.productGroupArray.removeAll()
        self.productNameArray.removeAll()
        self.productImageUrlArray.removeAll()
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        
        VClient.sharedInstance().VCGetProductDataByType(type: typeSt) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            
            if isSuccess {
                if resDataArray.count != 0 {
                    
                    let groupIDArray = resDataArray[1] as? Array<Int> ?? []
                    let set = Set(groupIDArray)
                    let setArray = Array(set.sorted(by: <))
                    print("\(self.productGroupArray) === \(set.sorted(by: <))")
                    
                    for i in 0 ..< setArray.count {
                        let dict = self.processProductData(gID: setArray[i], resDataArray: resDataArray)
                        let array = dict[setArray[i]] ?? []
                        let order_Array = array[0] as? Array<Int> ?? []
                        let groupID_Array = array[1] as? Array<Int> ?? []
                        let name_Array = array[2] as? Array<String> ?? []
                        let imageUrl_Array = array[3] as? Array<String> ?? []
                        
                        self.productOrderArray.append(order_Array[0])
                        self.productGroupArray.append(groupID_Array[0])
                        self.productNameArray.append(name_Array[0])
                        self.productImageUrlArray.append(imageUrl_Array[0])
                    }
                    
                    self.defaultDownloadImage()
                    
                }else{
                    self.cav = CustomAlertView.init(title: message, btnTitle: NSLocalizedString("Alert_Sure_title", comment: ""), tag: 0, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    self.cav.delegate = self
                    self.view.addSubview(self.cav)
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
    
    // 預設下載圖片載入(10張)
    
    func defaultDownloadImage() {
        
        self.productImageDataArray.removeAll()
        self.productTmpImageUrlArray.removeAll()
        
        var j = 10
        if self.productImageUrlArray.count < 10 {
            j = self.productImageUrlArray.count
        }
        
        for i in 0 ..< j {
            let urlSt:String = self.productImageUrlArray[i]
            let url = URL.init(string: urlSt)
            if url != nil {
                self.productTmpImageUrlArray.append(url!)
            }
        }
        self.productTableView.reloadData()
    }
    
    // 下載圖片
    
    func downloadImage(currentCount:Int) {
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        var newCount = currentCount + 10
        let lastCount = self.productImageUrlArray.count - (self.productImageUrlArray.count % 10)
        if currentCount == lastCount {
            newCount = self.productImageUrlArray.count
        }
            
        DispatchQueue.global(qos: .userInitiated).async {
            for i in currentCount ..< newCount {
                
                let urlSt:String = self.productImageUrlArray[i]
                let url = URL.init(string: urlSt)
                if url != nil {

                    self.productTmpImageUrlArray.append(url!)
                }
            }
            
            DispatchQueue.main.async {
                self.productTableView.reloadData()
                self.flag = 0
                self.vaiv.stopProgressHUD(view: self.view)
            }
        }
    }
    
    // 處理取得的商品資料 因為資料
    
    func processProductData(gID:Int,resDataArray:Array<Array<Any>>) -> [Int:Array<Any>] {
        
        let orderArray = resDataArray[0] as? Array<Int> ?? []
        let groupArray = resDataArray[1] as? Array<Int> ?? []
        let nameArray = resDataArray[2] as? Array<String> ?? []
        let imageUrlArray = resDataArray[3] as? Array<String> ?? []
        
        var dataDict:[Int:Array<Any>] = [:]
        var dataArray:Array<Any> = []
        
        var pOrderArray:Array<Int> = []
        var pGroupArray:Array<Int> = []
        var pNameArray:Array<String> = []
        var pImageUrlArray:Array<String> = []
        
        for i in 0 ..< orderArray.count {
            let order:Int = orderArray[i]
            let groupID:Int = groupArray[i]
            let name:String = nameArray[i]
            let imageUrl:String = imageUrlArray[i]
            
            if groupID == gID {
                
                pOrderArray.append(order)
                pGroupArray.append(groupID)
                pNameArray.append(name)
                pImageUrlArray.append(imageUrl)
            }
        }
        
        dataArray = [pOrderArray,pGroupArray,pNameArray,pImageUrlArray]
        dataDict.updateValue(dataArray, forKey: gID)
        return dataDict
        
    }
    
    // 取得購物車數量
    
    func GetShoppingCarDataCount() {
        
        self.IDArray.removeAll()
        VClient.sharedInstance().VCGetShoppingCarData { (_ dataArray:Array<Array<Any>>,_ isDone:Bool) in
            if isDone {
                if dataArray.count != 0 {
                    self.IDArray = dataArray[0] as? Array<Int> ?? []
                    self.bHub?.setCount(self.IDArray.count)
                }else{
                    self.bHub?.setCount(0)
                }
            }
        }
    }
    
    
    // MARK: - Action
    
    @objc func rightBtnClick(_ sender:UIButton) {
        self.userDefault.set(1, forKey: "backDefault")
        self.navigationController?.popToRootViewController(animated: false)
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
        
        return self.productTmpImageUrlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ProductListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProdectCell", for: indexPath) as! ProductListTableViewCell
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let selectBkView = UIView()
        selectBkView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBkView

        let name:String = self.productNameArray[indexPath.row]
        let urlSt:String = self.productImageUrlArray[indexPath.row]
        let url = URL.init(string: urlSt)
        cell.loadData(titleSt: name, url: url!)
        
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("==\(indexPath.row)")
        let vc = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
        vc.groupID = self.productGroupArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - UIScrollViewDelegate

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let heigh = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let bottomOffset = scrollView.contentSize.height - contentOffsetY
//        print("h = \(heigh)  c = \(contentOffsetY)  b = \(bottomOffset) --\(scrollView.contentSize.height)")

        if bottomOffset <= heigh {

            if self.productTmpImageUrlArray.count >= self.productImageUrlArray.count {

            }else{
                print("----End----")
                flag+=1
                if flag == 1 {
                    print("----bbb----")
                    self.downloadImage(currentCount: self.productTmpImageUrlArray.count)
                }
            }
        }
    }
    
    //MARK: - CustomAlertViewDelegate
    
    func alertBtnClick(btnTag: Int) {
        self.cav.removeFromSuperview()
    }

}
