//
//  VClient.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import Foundation
import UIKit

class VClient {
    
    private static var mInstance:VClient?
    private let userDefault = UserDefaults.standard
    private var tds_userID:String? = ""
    
    static func sharedInstance() -> VClient {
        if mInstance == nil {
            mInstance = VClient();
        }
        return mInstance!
    }
    private init(){}
}
