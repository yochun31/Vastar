//
//  VActivityIndicatorView.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import UIKit

class VActivityIndicatorView: NSObject {

    var hud = MBProgressHUD()
    
    func startProgressHUD(view:UIView,content:String) {
        
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = content
        view.isUserInteractionEnabled = false
    }
    
    
    func stopProgressHUD(view:UIView) {
        view.isUserInteractionEnabled = true
        
        MBProgressHUD.hide(for: view, animated: true)
    }
}
