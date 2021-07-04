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
    
    var menuTitle:String = ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setSideMenuTableView()
        
    }
    
    
    // MARK: - UI Interface Methods

    
    func setSideMenuTableView() {
        
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "sidemenuCell")
        self.sideMenuTableView.backgroundColor = UIColor.init(red: 0.0/255.0, green: 61.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        self.sideMenuTableView.separatorStyle = .none
        
        self.sideBarTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
        self.section0_menuItemArray = [NSLocalizedString("SideBar_Menu_Section0_row0_title", comment: ""),NSLocalizedString("SideBar_Menu_Section0_row1_title", comment: ""),NSLocalizedString("SideBar_Menu_Section0_row2_title", comment: "")]
        self.section1_menuItemArray = [NSLocalizedString("SideBar_Menu_Section1_row0_title", comment: ""),NSLocalizedString("SideBar_Menu_Section1_row1_title", comment: "")]
        self.section2_menuItemArray = [NSLocalizedString("SideBar_Menu_Section2_row0_title", comment: ""),NSLocalizedString("SideBar_Menu_Section2_row1_title", comment: ""),NSLocalizedString("SideBar_Menu_Section2_row2_title", comment: "")]
        
        self.sideBarTitleLabel.text = menuTitle
        
    }
    
    //MARK:- Assistant Methods

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
        return 3
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
            cellcount = self.section2_menuItemArray.count
            break
        default:
            break
        }
        
        return cellcount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sidemenuCell", for: indexPath) as! SideMenuTableViewCell
        
        cell.backgroundColor = UIColor.init(red: 0.0/255.0, green: 61.0/255.0, blue: 36.0/255.0, alpha: 1.0)
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
            let titleString = self.section2_menuItemArray[indexPath.row]
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
        case 0:
            break
        case 1:
            title = NSLocalizedString("SideBar_Menu_Section1_title", comment: "")
            break
        case 2:
            title = NSLocalizedString("SideBar_Menu_Section2_title", comment: "")
            break
        default:
            break
        }
        
        return title
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        view.tintColor = UIColor.init(red: 0.0/255.0, green: 61.0/255.0, blue: 36.0/255.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 || section == 2 {
            return 50.0
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
        
        if section == 0 {
            switch rowIndex {
            case 0:
                let vc = VideoViewController(nibName: "VideoViewController", bundle: nil)
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break
            case 1:
                let vc = ProductViewController(nibName: "ProductViewController", bundle: nil)
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
    
                break
            case 2:
                
                let vc = ShoppingCarViewController(nibName: "ShoppingCarViewController", bundle: nil)
                vc.accountPhone = menuTitle
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break
            default:
                break
            }
        }else if section == 1 {
            
            switch rowIndex {
            case 0:
                let vc = OrderViewController(nibName: "OrderViewController", bundle: nil)
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break
            case 1:
                let vc = HistoryOrderViewController(nibName: "HistoryOrderViewController", bundle: nil)
                nav.viewControllers = [vc]
                reveal?.pushFrontViewController(nav, animated: true)
                
                break

            default:
                break
            }
        }else if section == 2 {
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
                VAlertView.presentAlert(title: NSLocalizedString("Alert_title", comment: ""), message: NSLocalizedString("LogOut_Alert_Text", comment: ""), actionTitle: [NSLocalizedString("Alert_Sure_title", comment: "")], preferredStyle: .alert, viewController: self) { (btnIndex, btnTitle) in
                    if btnIndex == 1 {
//                        self.dismiss(animated: true, completion: nil)
                        VClient.sharedInstance().VCDeleteAllShoppingCarData { isDone in
                            if isDone {
                                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                    }
                }
                
                break
            default:
                break
            }
        }
        
    }
    
}
