//
//  AppInfoManager.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/9.
//

import Foundation
import UIKit
import CryptoSwift

enum VMemberDataEditBtnItem:Int {
    case VMemberDataEditBtnEdit = 0, VMemberDataEditBtnConfirm
}

enum VProductItem:Int {
    case VProductAll = 0, VProductElectricStove,VProductElectricHeater,VProductOven,VProductFryPan,VProductVastar,VProductDetergent
}

enum VVideoPlayerStatusItem:Int {
    case VVideoPlayerStatusPlay = 0, VVideoPlayerStatusPause, VVideoPlayerStatusBack, VVideoPlayerStatusError
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

extension String {

    func aesEncrypt(key: String) throws -> String {

        var result = ""

        do {

            let key: [UInt8] = Array(key.utf8) as [UInt8]
            let aes = try AES(key: key, blockMode: ECB(), padding: .pkcs5) // AES128 .ECB pkcs7
            let encrypted = try aes.encrypt(Array(self.utf8))

            result = encrypted.toBase64()

            print("AES Encryption Result: \(result)")

        } catch {

            print("Error: \(error)")
        }

        return result
    }

    func aesDecrypt(key: String) throws -> String {

        var result = ""

        do {

            let encrypted = self
            let key: [UInt8] = Array(key.utf8) as [UInt8]
            let aes = try AES(key: key, blockMode: ECB(), padding: .pkcs5) // AES128 .ECB pkcs7
            let decrypted = try aes.decrypt(Array(base64: encrypted))

            result = String(data: Data(decrypted), encoding: .utf8) ?? ""

            print("AES Decryption Result: \(result)")

        } catch {

            print("Error: \(error)")
        }

        return result
    }
}


