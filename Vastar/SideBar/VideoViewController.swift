//
//  VideoViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/1.
//

import UIKit
import BadgeHub

class VideoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var videoListTableView: UITableView!
    @IBOutlet var typeBtn: UIButton!
    
    private var videoOrderArray:Array<Int> = []
    private var vimeoIDArray:Array<String> = []
    private var videoSeriesArray:Array<String> = []
    private var videoNameArray:Array<String> = []
    private var videoImageUrlArray:Array<String> = []
    
    private var rightNavBtn = UIButton()
    private var rightBarBtnItem = UIBarButtonItem()
    private var bHub:BadgeHub?
    private var IDArray:Array<Int> = []
    
    let userDefault = UserDefaults.standard
    var accountPhone:String = ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLeftBarButton()
        setRightBarButton()
        setInterface()
        setupSWReveal()
        setTableView()
        
        getVideoAllList()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let flag:Int = self.userDefault.object(forKey: "backDefault")as? Int ?? 0
        if flag == 1 {
            self.userDefault.set(0, forKey: "backDefault")
            let nav = UINavigationController()
            let reveal = self.revealViewController()
            let vc = ShoppingCarViewController(nibName: "ShoppingCarViewController", bundle: nil)
            vc.accountPhone = accountPhone
            nav.viewControllers = [vc]
            reveal?.pushFrontViewController(nav, animated: true)
        }else{
            GetShoppingCarDataCount()
        }
    }

    
    //MARK: - UI Interface Methods
    
    func setLeftBarButton() {
        let leftBarBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBarBtn.setImage(UIImage(named: "menu"), for: .normal)
        leftBarBtn.addTarget(self, action: #selector(leftBarBtnClick(_:)), for: .touchUpInside)
        let leftBarItem = UIBarButtonItem(customView: leftBarBtn)
        self.navigationItem.leftBarButtonItem = leftBarItem
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
    
    func setInterface() {
        self.navigationItem.title = NSLocalizedString("Video_title", comment: "")
        
        self.typeBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.typeBtn.addTarget(self, action: #selector(typeBtnClick(_:)), for: .touchUpInside)
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
    
    
    func setTableView() {
        
        self.videoListTableView.delegate = self
        self.videoListTableView.dataSource = self
        
        self.videoListTableView.register(UINib(nibName: "VideoListTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        self.videoListTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    //MARK: - Assistant Methods
    
    func getVideoAllList() {
        
        VClient.sharedInstance().VCGetVideoListByType(type: "") { (_ isSuccess:Bool,_ message:String,_ resDataArray:Array<Array<Any>>) in
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
    
    //MARK: - Action
    
    @objc func leftBarBtnClick(_ sender:UIButton) {
        print("33333333")
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    @objc func rightBtnClick(_ sender:UIButton) {
        
        let nav = UINavigationController()
        let reveal = self.revealViewController()
        let vc = ShoppingCarViewController(nibName: "ShoppingCarViewController", bundle: nil)
        vc.accountPhone = accountPhone
        nav.viewControllers = [vc]
        reveal?.pushFrontViewController(nav, animated: true)
    }
    
    @objc func typeBtnClick(_ sender:UIButton) {
        
        let vc = ConnectionViewController(nibName: "ConnectionViewController", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
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
