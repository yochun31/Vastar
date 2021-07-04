//
//  CustomButton.swift
//  TDS_Farmer
//
//  Created by geosat on 2020/2/24.
//  Copyright © 2020 geosat. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var customInputView = UIView()
    var toolBarView = UIView()
    
    var textString:String?
    
    override var inputView: UIView {
        get {
            return customInputView
        }
        
        set {
            self.customInputView = newValue
        }
    }
    
    override var inputAccessoryView: UIView {
        get {
            return self.toolBarView
        }
        set {
            self.toolBarView = newValue
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}
