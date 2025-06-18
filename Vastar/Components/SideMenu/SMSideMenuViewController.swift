//
//  SMSideMenuViewController.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/1.
//

import UIKit

protocol SMSideMenuSelectDelegate {
    func selectedCell(section:Int,row:Int)
}

class SMSideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet var sideBarTitleLabel: UILabel!
    
    var delegate:SMSideMenuSelectDelegate?
    
    private var section0_menuItemArray:Array<String> = []
    
    private var section1_menuItemArray:Array<String> = []
    
    private var section2_menuItemArray:Array<String> = []
    private var section2_Open:Bool = false
    private var section2_Sub0_ItemArray:Array<String> = []

    
    private var section3_menuItemArray:Array<String> = []
    private var section3_Open:Bool = false
    private var section3_Sub0_ItemArray:Array<String> = []

    
    
    private var section4_menuItemArray:Array<String> = []
    private var section5_menuItemArray:Array<String> = []
    private var section6_menuItemArray:Array<String> = []
    
    private var vastarWeb:String = ""
    
    
    var menuTitle:String = ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setSideMenuTableView()
        getCanteenList()
        getFoodTypeList()
        getVasterWebUrl()
    }
    
    
    // MARK: - UI Interface Methods

    
    func setSideMenuTableView() {
        
        self.view.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "sidemenuCell")
        self.sideMenuTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        self.sideMenuTableView.separatorStyle = .none
        
        self.sideBarTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.section0_menuItemArray = [NSLocalizedString("SideBar_Menu_Section0_title", comment: "")]
        
        self.section1_menuItemArray = [NSLocalizedString("SideBar_Menu_Section1_title", comment: "")]
        
        self.section2_menuItemArray = [NSLocalizedString("SideBar_Menu_Section2_title", comment: "")]
        
        
        self.section3_menuItemArray = [NSLocalizedString("SideBar_Menu_Section3_title", comment: "")]
        
        
        self.section4_menuItemArray = [NSLocalizedString("SideBar_Menu_Section4_row0_title", comment: ""),NSLocalizedString("SideBar_Menu_Section4_row1_title", comment: "")]
        self.section5_menuItemArray = [NSLocalizedString("SideBar_Menu_Section5_row0_title", comment: ""),NSLocalizedString("SideBar_Menu_Section5_row1_title", comment: "")]
        self.section6_menuItemArray = [NSLocalizedString("SideBar_Menu_Section6_row0_title", comment: ""),NSLocalizedString("SideBar_Menu_Section6_row1_title", comment: ""),NSLocalizedString("SideBar_Menu_Section6_row2_title", comment: ""),NSLocalizedString("SideBar_Menu_Section6_row3_title", comment: "")]
        
        
        self.sideBarTitleLabel.text = menuTitle
        
    }

    
    //MARK:- Assistant Methods
    
    func getCanteenList() {
        
        VClient.sharedInstance().VCGetVideoCanteenList { isSuccess, message, resDataArray in
            if isSuccess {
                
                self.section2_Sub0_ItemArray = resDataArray
                
                self.sideMenuTableView.reloadData()
            }
        }
    }
    
    func getFoodTypeList() {
        
        VClient.sharedInstance().VCGetVideoFoodTypeList { isSuccess, message, resDataArray in
            if isSuccess {
                self.section3_Sub0_ItemArray = resDataArray
                print("---->\(resDataArray)")
                self.sideMenuTableView.reloadData()
            }
        }
    }
    
    func getVasterWebUrl() {
        
        VClient.sharedInstance().VCGetVastarURLData { isSuccess, message, resData in
            if isSuccess {
                self.vastarWeb = resData
                self.sideMenuTableView.reloadData()
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
        return 7
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var cellcount:Int = 0
        switch section {
        case 0:
            cellcount = self.section0_menuItemArray.count
            break
        case 1:
            cellcount = self.section1_menuItemArray.count
            break
        case 2:
            if section2_Open == true {
                cellcount = self.section2_Sub0_ItemArray.count + 1
            }else{
                cellcount = 1
            }
            break
        case 3:
            if section3_Open == true {
                cellcount = self.section3_Sub0_ItemArray.count + 1
            }else{
                cellcount = 1
            }
            break
        case 4:
            cellcount = self.section4_menuItemArray.count
            break
        case 5:
            cellcount = self.section5_menuItemArray.count
            break
        case 6:
            cellcount = self.section6_menuItemArray.count
            break
        default:
            break
        }
        
        return cellcount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataIndex = indexPath.row - 1
        let cell:SideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sidemenuCell", for: indexPath) as! SideMenuTableViewCell
        
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
        let selectBkView = UIView()
        selectBkView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectBkView
        
        let icon:UIImage = UIImage(named: "box")!
        switch indexPath.section {
        case 0:
            let titleString = self.section0_menuItemArray[indexPath.row]
            cell.loadCellData(icon: icon, title: titleString)
            break
        case 1:
            let titleString = self.section1_menuItemArray[indexPath.row]
            cell.loadCellData(icon: icon, title: titleString)
            break
        case 2:
            if indexPath.row == 0 {
                let titleString = self.section2_menuItemArray[indexPath.row]
                cell.loadCellData(icon: icon, title: titleString)
            }else{
                let cell_1:SideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sidemenuCell", for: indexPath) as! SideMenuTableViewCell
                cell_1.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
                let selectBkView = UIView()
                selectBkView.backgroundColor = UIColor.clear
                cell_1.selectedBackgroundView = selectBkView
                let titleString = self.section2_Sub0_ItemArray[dataIndex]
                cell_1.loadCellData(title: titleString)
                return cell_1
            }
            break
        case 3:
            if indexPath.row == 0 {
                let titleString = self.section3_menuItemArray[indexPath.row]
                cell.loadCellData(icon: icon, title: titleString)
            }else{
                let cell_2:SideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sidemenuCell", for: indexPath) as! SideMenuTableViewCell
                cell_2.backgroundColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
                let selectBkView = UIView()
                selectBkView.backgroundColor = UIColor.clear
                cell_2.selectedBackgroundView = selectBkView
                let titleString = self.section3_Sub0_ItemArray[dataIndex]
                cell_2.loadCellData(title: titleString)
                return cell_2
            }
            break
        case 4:
            let titleString = self.section4_menuItemArray[indexPath.row]
            cell.loadCellData(icon: icon, title: titleString)
            break
        case 5:
            let titleString = self.section5_menuItemArray[indexPath.row]
            cell.loadCellData(icon: icon, title: titleString)
            break
        case 6:
            let titleString = self.section6_menuItemArray[indexPath.row]
            cell.loadCellData(icon: icon, title: titleString)
            break
        default:
            break
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title:String = ""
        switch section {
        case 5:
            title = NSLocalizedString("SideBar_Menu_Section5_title", comment: "")
            break
        case 6:
            title = NSLocalizedString("SideBar_Menu_Section6_title", comment: "")
            break
        default:
            break
        }
        
        return title
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        view.tintColor = UIColor.init(red: 0.0/255.0, green: 36.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 5 || section == 6 {
            return 50.0
        }else if section == 2 || section == 3 || section == 4 || section == 1{
            return 0
        }else if section == 0 {
            return 0.5
        }else{
            return 10.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.selectedCell(section: indexPath.section, row: indexPath.row)
        print("section = \(indexPath.section)  row = \(indexPath.row)")
        
        let nav = UINavigationController()
        let reveal = self.revealViewController()
        
        let section = indexPath.section
        let rowIndex = indexPath.row
        let dataIndex = rowIndex - 1
        
        if section == 0 {
            let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
            vc.accountPhone = menuTitle
            nav.viewControllers = [vc]
            reveal?.pushFrontViewController(nav, animated: true)
        }else if section == 1 {
            if let url = URL(string: self.vastarWeb) {
                UIApplication.shared.open(url)
            }
        }else if section == 2 {
            if rowIndex == 0 {
                if section2_Open == true {
                    section2_Open = false
                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                }else{
                    section2_Open = true
                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                }
            }else{
                let vc = CanteenVideoListViewController(nibName: "CanteenVideoListViewController", bundle: nil)
                vc.accountPhone = menuTitle
                vc.seriesSt = self.section2_Sub0_ItemArray[dataIndex]
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
            }
            
            
        }else if section == 3 {
            if rowIndex == 0 {
                if section3_Open == true {
                    section3_Open = false
                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                }else{
                    section3_Open = true

                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                }
            }else{
                let vc = FoodTypeVideoListViewController(nibName: "FoodTypeVideoListViewController", bundle: nil)
                vc.accountPhone = menuTitle
                vc.typeSt = self.section3_Sub0_ItemArray[dataIndex]
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
            }
            
            
        }else if section == 4 {
            switch rowIndex {
            case 0:
                let vc = ProductViewController(nibName: "ProductViewController", bundle: nil)
                vc.accountPhone = menuTitle
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break
            case 1:
                let vc = ShoppingCarViewController(nibName: "ShoppingCarViewController", bundle: nil)
                vc.accountPhone = menuTitle
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break

            default:
                break
            }
            
        }else if section == 5 {
            switch rowIndex {
            case 0:
                let vc = OrderListViewController(nibName: "OrderListViewController", bundle: nil)
                vc.accountPhone = menuTitle
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break
            case 1:
                let vc = HistoryOrderViewController(nibName: "HistoryOrderViewController", bundle: nil)
                vc.accountPhone = menuTitle
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break

            default:
                break
            }
            
        }else if section == 6 {
            switch rowIndex {
            case 0:
                let vc = MemberDataViewController(nibName: "MemberDataViewController", bundle: nil)
                vc.accountPhone = menuTitle
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break
            case 1:
                let vc = ChangePwViewController(nibName: "ChangePwViewController", bundle: nil)
                vc.accountPhone = menuTitle
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break
            case 2:
                let vc = DeleteUserViewController(nibName: "DeleteUserViewController", bundle: nil)
                vc.accountSt = menuTitle
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break
            case 3:
                VClient.sharedInstance().VCDeleteAllShoppingCarData { isDone in
                    if isDone {
                        UserDefaults.standard.set(true, forKey: "C2")
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
                
                break
            default:
                break
            }
        }
        
    }
}
