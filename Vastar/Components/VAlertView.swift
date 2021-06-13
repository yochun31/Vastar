//
//  VAlertView.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import UIKit

class VAlertView: NSObject {
    
    static func presentAlert(title:String,message:String,actionTitle:String,viewController:UIViewController,handler:@escaping ()->Void){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (action:UIAlertAction) in
            handler()
        }
        alert.addAction(action)
        viewController.present(alert,animated: true, completion: nil);
        
    }
    
    static func presentAlertMultipleAction(title:String,message:String,actionTitle:Array<String>,preferredStyle:UIAlertController.Style,viewController:UIViewController,handler:@escaping (_ buttonIndex:Int,_ buttonTitle:String)->Void){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for i in 0..<actionTitle.count {
            let confirmAction = UIAlertAction(title: actionTitle[i], style: .default, handler: {(action:UIAlertAction) ->()in
                handler((i+1),actionTitle[i])
            })
            alert.addAction(confirmAction);
        }
        viewController.present(alert,animated: true, completion: nil);
    }
    
    
    static func presentAlert(title:String,message:String,actionTitle:Array<String>,preferredStyle:UIAlertController.Style,viewController:UIViewController,handler:@escaping (_ buttonIndex:Int,_ buttonTitle:String)->Void){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for i in 0..<actionTitle.count {
            let confirmAction = UIAlertAction(title: actionTitle[i], style: .default, handler: {(action:UIAlertAction) ->()in
                handler((i+1),actionTitle[i])
            })
            alert.addAction(confirmAction);
        }
        
        let cancelButton = UIAlertAction(title: NSLocalizedString("Alert_Cancel_title", comment: ""), style: .destructive, handler: nil)
        alert.addAction(cancelButton)
        viewController.present(alert,animated: true, completion: nil);
    
    }

}
