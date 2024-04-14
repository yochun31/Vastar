//
//  VideoDetailViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/9/29.
//

import UIKit
import HCVimeoVideoExtractor
import AVKit
import GPVideoPlayer
import TRVideoView

class VideoDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var productTableView: UITableView!
    @IBOutlet var vimeoPlayView: UIView!
    @IBOutlet var errorDisplayImg: UIImageView!
    private var productTypeArray:Array<String> = []
    private var productModelArray:Array<String> = []
    
    private var productDictData:[String:Array<Any>] = [:]
    
    private var gpPlayer = GPVideoPlayer()
    
    
    
    var productDataArray:Array<Any> = []
    var vimeoIDSt:String = ""
    var titleSt:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.productTypeArray = productDataArray[0] as? Array<String> ?? []
        self.productModelArray = productDataArray[1] as? Array<String> ?? []
        
        
        
        setTableView()
        getProductListData()
        self.errorDisplayImg.isHidden = true
        self.playView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vimeoPlayView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.navigationItem.title = titleSt
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)



    }
    
    
    //MARK: - UI Interface Methods
    
    // 設定UI介面
    
    func setTableView() {
        
        self.productTableView.delegate = self
        self.productTableView.dataSource = self
        
        self.productTableView.register(UINib(nibName: "VideoProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoProdectCell")
        self.productTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(leftbackBtnClick(_:)))
    }
    
    
    //MARK: - Assistant Methods
    
    func getProductListData() {
        
        VClient.sharedInstance().VCGetProductInfoByNo(productNoArray: productModelArray) { (_ isSuccess:Bool,_ message:String,_ resDataDict:[String:Array<Any>]) in
            
            if isSuccess {
                
                self.productDictData = resDataDict
                
                self.productTableView.reloadData()
            }
        }
        
    }
    
    func playView() {
        
        let url = URL(string: "https://vimeo.com/\(vimeoIDSt)")!
        print("URL = \(url)")
        
        let video = TRVideoView(text: "https://vimeo.com/\(vimeoIDSt)", allowInlinePlayback: true)
    
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width

        // Set the frame as always, or use AutoLayout
        print("vimeoPlay = \(self.vimeoPlayView.frame)")
        video.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.vimeoPlayView.frame.height)
        video.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        print("video = \(video.frame)")
        
        // Returns String with out URLs (i.e. "This is some sample text with a YouTube link")
//        let text = video.textWithoutURLs()

        // Finally add it to your view
        self.vimeoPlayView.addSubview(video)
        
    }
    
    //MARK: - Action
    
    @objc func leftbackBtnClick(_ sender:UIButton) {

        self.navigationController?.popViewController(animated: true)
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
        
        return productModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:VideoProductListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoProdectCell", for: indexPath) as! VideoProductListTableViewCell
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        let selectBkView = UIView()
        selectBkView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBkView
        
        let typeSt:String = self.productTypeArray[indexPath.row]
        
        let model:String = self.productModelArray[indexPath.row]
        
        let dataArray = self.productDictData[model] ?? []
        print("===>\(dataArray)")
        if dataArray.count != 0 {
            let urlSt:String = dataArray[0] as? String ?? ""
            let name:String = dataArray[1] as? String ?? ""
            let url = URL.init(string: urlSt)
            cell.loadData(typeSt: typeSt, titleSt: name, url: url!)
        }

        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("==\(indexPath.row)")
        let vc = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
        let model:String = self.productModelArray[indexPath.row]
        let dataArray = self.productDictData[model] ?? []
        let groupID:Int = dataArray[2] as? Int ?? 0
        vc.groupID = groupID
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
