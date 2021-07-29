//
//  ProductViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import UIKit

class ProductViewController: UIViewController {
    
    
    @IBOutlet var allProductBtn: UIButton!
    
    @IBOutlet var product_Item1_Btn: UIButton!
    @IBOutlet var product_Item2_Btn: UIButton!
    
    @IBOutlet var product_Item3_Btn: UIButton!
    @IBOutlet var product_Item4_Btn: UIButton!
    
    @IBOutlet var product_Item5_Btn: UIButton!
    @IBOutlet var product_Item6_Btn: UIButton!
    
    let userDefault = UserDefaults.standard

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLeftBarButton()
        setInterface()
        setupSWReveal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let flag:Int = self.userDefault.object(forKey: "backDefault")as? Int ?? 0
        if flag == 1 {
            self.userDefault.set(0, forKey: "backDefault")
            let nav = UINavigationController()
            let reveal = self.revealViewController()
            let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
            nav.viewControllers = [vc]
            reveal?.pushFrontViewController(nav, animated: true)
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
    
    func setupSWReveal(){
        //adding panGesture to reveal menu controller
        view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
        //adding tap gesture to hide menu controller
        view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        //setting reveal width of menu controller manually
        self.revealViewController()?.rearViewRevealWidth = UIScreen.main.bounds.width * (2/3)
        
//        self.revealViewController()?.delegate = self
        
    }
    
    func setInterface() {
        self.navigationItem.title = NSLocalizedString("Product_title", comment: "")
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        self.allProductBtn.setTitle(NSLocalizedString("Product_All_Btn_title", comment: ""), for: .normal)
        self.allProductBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.allProductBtn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        self.allProductBtn.addTarget(self, action: #selector(allProductBtnClick(_:)), for: .touchUpInside)
        
        self.product_Item1_Btn.setTitle(NSLocalizedString("Product_Item1_Btn_title", comment: ""), for: .normal)
        self.product_Item1_Btn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.product_Item1_Btn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        self.product_Item1_Btn.addTarget(self, action: #selector(product_Item1_BtnClick(_:)), for: .touchUpInside)

        
        self.product_Item2_Btn.setTitle(NSLocalizedString("Product_Item2_Btn_title", comment: ""), for: .normal)
        self.product_Item2_Btn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.product_Item2_Btn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        self.product_Item2_Btn.addTarget(self, action: #selector(product_Item2_BtnClick(_:)), for: .touchUpInside)

        
        
        self.product_Item3_Btn.setTitle(NSLocalizedString("Product_Item3_Btn_title", comment: ""), for: .normal)
        self.product_Item3_Btn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.product_Item3_Btn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        self.product_Item3_Btn.addTarget(self, action: #selector(product_Item3_BtnClick(_:)), for: .touchUpInside)
     
        
        
        self.product_Item4_Btn.setTitle(NSLocalizedString("Product_Item4_Btn_title", comment: ""), for: .normal)
        self.product_Item4_Btn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.product_Item4_Btn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        self.product_Item4_Btn.addTarget(self, action: #selector(product_Item4_BtnClick(_:)), for: .touchUpInside)

        
        
        self.product_Item5_Btn.setTitle(NSLocalizedString("Product_Item5_Btn_title", comment: ""), for: .normal)
        self.product_Item5_Btn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.product_Item5_Btn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        self.product_Item5_Btn.addTarget(self, action: #selector(product_Item5_BtnClick(_:)), for: .touchUpInside)
        
        
        self.product_Item6_Btn.setTitle(NSLocalizedString("Product_Item6_Btn_title", comment: ""), for: .normal)
        self.product_Item6_Btn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        self.product_Item6_Btn.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 24.0)
        self.product_Item6_Btn.addTarget(self, action: #selector(product_Item6_BtnClick(_:)), for: .touchUpInside)
        self.product_Item1_Btn.addTarget(self, action: #selector(product_Item1_BtnClick(_:)), for: .touchUpInside)
    }
    
    
    //MARK: - Action
    
    @objc func leftBarBtnClick(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    @objc func allProductBtnClick(_ sender:UIButton) {
        
        let vc = ProductListViewController(nibName: "ProductListViewController", bundle: nil)
        vc.productItemID = VProductItem.VProductAll.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func product_Item1_BtnClick(_ sender:UIButton) {
        
        let vc = ProductListViewController(nibName: "ProductListViewController", bundle: nil)
        vc.productItemID = VProductItem.VProductElectricStove.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func product_Item2_BtnClick(_ sender:UIButton) {
        
        let vc = ProductListViewController(nibName: "ProductListViewController", bundle: nil)
        vc.productItemID = VProductItem.VProductElectricHeater.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func product_Item3_BtnClick(_ sender:UIButton) {
        
        let vc = ProductListViewController(nibName: "ProductListViewController", bundle: nil)
        vc.productItemID = VProductItem.VProductOven.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func product_Item4_BtnClick(_ sender:UIButton) {
        
        let vc = ProductListViewController(nibName: "ProductListViewController", bundle: nil)
        vc.productItemID = VProductItem.VProductFryPan.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func product_Item5_BtnClick(_ sender:UIButton) {
        
        let vc = ProductListViewController(nibName: "ProductListViewController", bundle: nil)
        vc.productItemID = VProductItem.VProductVastar.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func product_Item6_BtnClick(_ sender:UIButton) {
        
        let vc = ProductListViewController(nibName: "ProductListViewController", bundle: nil)
        vc.productItemID = VProductItem.VProductDetergent.rawValue
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

}
