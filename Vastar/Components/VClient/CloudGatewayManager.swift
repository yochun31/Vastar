//
//  CloudGatewayManager.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/3.
//

import Foundation
import UIKit
import Alamofire

class CloudGatewayManager {
    
    private static var mInstance:CloudGatewayManager?
    static func sharedInstance() -> CloudGatewayManager {
        if mInstance == nil {
            mInstance = CloudGatewayManager();
        }
        return mInstance!
    }
    private init(){}
}
