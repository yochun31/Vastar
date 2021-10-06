//
//  VideoListByTypeViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/9/28.
//

import UIKit

class VideoListByTypeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var videoListTableView: UITableView!
    
    private var videoOrderArray:Array<Int> = []
    private var vimeoIDArray:Array<String> = []
    private var videoSeriesArray:Array<String> = []
    private var videoNameArray:Array<String> = []
    private var videoImageUrlArray:Array<String> = []
    
    var typeSt:String = ""
    var titleSt:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setInterface()
        setTableView()
        getVideoList()
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
    
    //MARK: - Assistant Methods
    
    func getVideoList() {
        
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
