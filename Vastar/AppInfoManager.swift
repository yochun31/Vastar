//
//  AppInfoManager.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/9.
//

import Foundation
import UIKit

enum VMemberDataEditBtnItem:Int {
    case VMemberDataEditBtnEdit = 0, VMemberDataEditBtnConfirm
}

enum VProductItem:Int {
    case VProductAll = 0, VProductElectricStove,VProductElectricHeater,VProductOven,VProductFryPan,VProductVastar,VProductDetergent
}


class AppInfoManager {
    
    func GetMemberDataEditBtnTitle(item:Int) -> String {
        
        var title:String = ""
        
        switch item {
        case VMemberDataEditBtnItem.VMemberDataEditBtnEdit.rawValue:
            title = NSLocalizedString("Member_Edit_Btn_title", comment: "")
            break
        case VMemberDataEditBtnItem.VMemberDataEditBtnConfirm.rawValue:
            title = NSLocalizedString("Member_Confirm_Btn_title", comment: "")
            break
        default:
            break
        }
        return title
    }
    
    func GetProductItemTitle(item:Int) -> String {
        
        var title:String = ""
        
        switch item {
        case VProductItem.VProductAll.rawValue:
            title = NSLocalizedString("Product_All_Btn_title", comment: "")
            break
        case VProductItem.VProductElectricStove.rawValue:
            title = NSLocalizedString("Product_Item1_Btn_title", comment: "")
            break
        case VProductItem.VProductElectricHeater.rawValue:
            title = NSLocalizedString("Product_Item2_Btn_title", comment: "")
            break
        case VProductItem.VProductOven.rawValue:
            title = NSLocalizedString("Product_Item3_Btn_title", comment: "")
            break
        case VProductItem.VProductFryPan.rawValue:
            title = NSLocalizedString("Product_Item4_Btn_title", comment: "")
            break
        case VProductItem.VProductVastar.rawValue:
            title = NSLocalizedString("Product_Item5_Btn_title", comment: "")
            break
        case VProductItem.VProductDetergent.rawValue:
            title = NSLocalizedString("Product_Item6_Btn_title", comment: "")
            break
        default:
            break
        }
        return title
    }
}

extension UITextField {
    
    func setTextColor(_ color: UIColor, font: UIFont) {

        self.textColor = color
        self.font = font
    }

    func setBottomBorder(with color: UIColor, width: CGFloat, bkColor:UIColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = bkColor.cgColor  // bg color of your choice

        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: width)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setPlaceHolderAttributes(placeHolderText : String, colour : UIColor , font : UIFont){

        self.attributedPlaceholder = NSAttributedString(string:placeHolderText, attributes:[NSAttributedString.Key.foregroundColor: colour , NSAttributedString.Key.font : font])
    }
    
    
}
