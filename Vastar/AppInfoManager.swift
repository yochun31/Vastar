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
}
