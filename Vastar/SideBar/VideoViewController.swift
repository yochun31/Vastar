//
//  VideoViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/1.
//

import UIKit

class VideoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var videoListTableView: UITableView!
    @IBOutlet var typeBtn: UIButton!
    
    private var videoOrderArray:Array<Int> = []
    private var vimeoIDArray:Array<String> = []
    private var videoSeriesArray:Array<String> = []
    private var videoNameArray:Array<String> = []
    private var videoImageUrlArray:Array<String> = []
    
    let userDefault = UserDefaults.standard
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLeftBarButton()
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
    
    //MARK: - Action
    
    @objc func leftBarBtnClick(_ sender:UIButton) {
        print("33333333")
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    @objc func typeBtnClick(_ sender:UIButton) {
        
        let vc = VideoTypeViewController(nibName: "VideoTypeViewController", bundle: nil)
        
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
