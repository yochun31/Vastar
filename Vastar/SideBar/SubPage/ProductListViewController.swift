//
//  ProductListViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/15.
//

import UIKit

class ProductListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    
    @IBOutlet var productTableView: UITableView!
    
    private var vaiv = VActivityIndicatorView()
    
    private var productOrderArray:Array<Int> = []
    private var productGroupArray:Array<Int> = []
    private var productNameArray:Array<String> = []
    private var productImageUrlArray:Array<String> = []
    private var productImageDataArray:Array<Data> = []
    
    let AppInfo = AppInfoManager()
    var productItemID:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setTableView()
        setProductTableData(item: productItemID)
    }
    
    //MARK: - UI Interface Methods
    
    func setTableView() {
        
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        
        self.productTableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProdectCell")
        self.productTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 61.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 61.0/255.0, blue: 36.0/255.0, alpha: 1.0)
    }
    
    //MARK: - Assistant Methods

    func setProductTableData(item:Int) {
        let type:String = AppInfo.GetProductItemTitle(item: item)
        
        
        if item == VProductItem.VProductAll.rawValue {
            self.getAllProductData()
        }else{
            self.getProductDataByType(typeSt: type)
        }
    }
    
    func getAllProductData() {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        VClient.sharedInstance().VCGetAllProductData { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            
            if isSuccess {
                if resDataArray.count != 0 {
                    self.productOrderArray = resDataArray[0] as? Array<Int> ?? []
                    self.productGroupArray = resDataArray[1] as? Array<Int> ?? []
                    self.productNameArray = resDataArray[2] as? Array<String> ?? []
                    self.productImageUrlArray = resDataArray[3] as? Array<String> ?? []
                    self.defaultDownloadImage()
                }else{
                    VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
                }
                
                self.vaiv.stopProgressHUD(view: self.view)
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            }
        }
    }
    
    func getProductDataByType(typeSt:String) {
        
        self.vaiv.startProgressHUD(view: self.view, content: NSLocalizedString("Alert_Loading_title", comment: ""))
        
        VClient.sharedInstance().CGMGetProductDataByType(type: typeSt) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            
            if isSuccess {
                if resDataArray.count != 0 {
                    self.productOrderArray = resDataArray[0] as? Array<Int> ?? []
                    self.productGroupArray = resDataArray[1] as? Array<Int> ?? []
                    self.productNameArray = resDataArray[2] as? Array<String> ?? []
                    self.productImageUrlArray = resDataArray[3] as? Array<String> ?? []
                    self.defaultDownloadImage()
                }else{
                    VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
                }
                
                self.vaiv.stopProgressHUD(view: self.view)
            }else{
                self.vaiv.stopProgressHUD(view: self.view)
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: message, actionTitle: NSLocalizedString("Alert_Sure_title", comment: ""), viewController: self) {}
            }
        }
    }
    
    func defaultDownloadImage() {
        
        self.productImageDataArray.removeAll()
        
        var j = 10
        if self.productImageUrlArray.count < 10 {
            j = self.productImageUrlArray.count
        }
        
        for i in 0 ..< j {
            let urlSt:String = self.productImageUrlArray[i]
            let url = URL.init(string: urlSt)
            if url != nil {
                let imageData = try? Data(contentsOf: url!)
                let defaultData = UIImage(named: "logo_item")!.pngData()
                self.productImageDataArray.append(imageData ?? defaultData!)
            }else{
                let defaultData = UIImage(named: "logo_item")!.pngData()
                self.productImageDataArray.append(defaultData!)
            }
        }
        self.productTableView.reloadData()
    }
    
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
                    let imageData = try? Data(contentsOf: url!)
                    let defaultData = UIImage(named: "logo_item")!.pngData()
                    self.productImageDataArray.append(imageData ?? defaultData!)
                }else{
                    let defaultData = UIImage(named: "logo_item")!.pngData()
                    self.productImageDataArray.append(defaultData!)
                }
            }
            
            DispatchQueue.main.async {
                self.productTableView.reloadData()
                self.vaiv.stopProgressHUD(view: self.view)
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
        
        return self.productImageDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ProductListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProdectCell", for: indexPath) as! ProductListTableViewCell
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 61.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        
        let selectBkView = UIView()
        selectBkView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBkView
        
        let name:String = self.productNameArray[indexPath.row]
        let photo:UIImage = UIImage(data: self.productImageDataArray[indexPath.row])!
  
        cell.loadData(productImage: photo, titleSt: name)
        
        
        return cell
    }
    
    
    //MARK: - UIScrollViewDelegate

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let heigh = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let bottomOffset = scrollView.contentSize.height - contentOffsetY
//        print("h = \(heigh)  c = \(contentOffsetY)  b = \(bottomOffset) --\(scrollView.contentSize.height)")
        
        if bottomOffset <= heigh {
            
            if self.productImageDataArray.count >= self.productImageUrlArray.count {
                
            }else{
                print("----End----")
                self.downloadImage(currentCount: self.productImageDataArray.count)
            }
        }
    }
}
