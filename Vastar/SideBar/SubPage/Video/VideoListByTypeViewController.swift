//
//  VideoListByTypeViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/9/28.
//

import UIKit
import BadgeHub

class VideoListByTypeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var videoListTableView: UITableView!
    
    private var videoOrderArray:Array<Int> = []
    private var vimeoIDArray:Array<String> = []
    private var videoSeriesArray:Array<String> = []
    private var videoNameArray:Array<String> = []
    private var videoImageUrlArray:Array<String> = []
    
    private var rightNavBtn = UIButton()
    private var rightBarBtnItem = UIBarButtonItem()
    private var bHub:BadgeHub?
    private var IDArray:Array<Int> = []
    
    var typeSt:String = ""
    var titleSt:String = ""
    var accountPhone:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setInterface()
        setTableView()
        setRightBarButton()
        getVideoAllList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        GetShoppingCarDataCount()
    }
    
    //MARK: - UI Interface Methods
    
    func setInterface() {
        self.navigationItem.title = self.titleSt
    }
    
    func setTableView() {
        
        self.videoListTableView.delegate = self
        self.videoListTableView.dataSource = self
        
        self.videoListTableView.register(UINib(nibName: "VideoListTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        self.videoListTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    func setRightBarButton() {
        
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
    
    func getVideoAllList() {
        
        VClient.sharedInstance().VCGetVideoListByType(type: self.typeSt) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            if isSuccess {
                
                self.videoOrderArray = resDataArray[0] as? Array<Int> ?? []
                self.vimeoIDArray = resDataArray[1] as? Array<String> ?? []
                self.videoSeriesArray = resDataArray[2] as? Array<String> ?? []
                self.videoNameArray = resDataArray[3] as? Array<String> ?? []
                self.videoImageUrlArray = resDataArray[4] as? Array<String> ?? []
                
                self.videoListTableView.reloadData()
            }
        }
    }
    
    func getVideoList() {
        
        VClient.sharedInstance().VCGetVideoListByProductType(type: self.typeSt) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
            if isSuccess {
                
                self.videoOrderArray = resDataArray[0] as? Array<Int> ?? []
                self.vimeoIDArray = resDataArray[1] as? Array<String> ?? []
                self.videoSeriesArray = resDataArray[2] as? Array<String> ?? []
                self.videoNameArray = resDataArray[3] as? Array<String> ?? []
                self.videoImageUrlArray = resDataArray[4] as? Array<String> ?? []
                
                self.videoListTableView.reloadData()
            }
        }
    }
    

    func getProductModelData(vimeoID:String,viewControllerTitle:String) {
        
        VClient.sharedInstance().VCGetVideoProductByID(vimeoID: vimeoID) { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Any>) in
            if isSuccess {
                
                print("=====>\(resDataArray)")
                
                let vc = VideoDetailViewController(nibName: "VideoDetailViewController", bundle: nil)
                vc.productDataArray = resDataArray
                vc.vimeoIDSt = vimeoID
                vc.titleSt = viewControllerTitle
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
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
        
        let nav = UINavigationController()
        let reveal = self.revealViewController()
        let vc = ShoppingCarViewController(nibName: "ShoppingCarViewController", bundle: nil)
        vc.accountPhone = accountPhone
        nav.viewControllers = [vc]
        reveal?.pushFrontViewController(nav, animated: true)
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
        
        return self.videoOrderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:VideoListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoListTableViewCell
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let selectBkView = UIView()
        selectBkView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBkView

        let series:String = self.videoSeriesArray[indexPath.row]
        let name:String = self.videoNameArray[indexPath.row]
        let urlSt:String = self.videoImageUrlArray[indexPath.row]
        let url = URL.init(string: urlSt)!
        cell.loadData(title1St: series, title2St: name, url: url)
        
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("==\(indexPath.row)")
        
        self.getProductModelData(vimeoID: self.vimeoIDArray[indexPath.row], viewControllerTitle: self.videoNameArray[indexPath.row])

    }

}
