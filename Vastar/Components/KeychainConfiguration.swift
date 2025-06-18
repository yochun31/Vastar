//
//  KeychainConfiguration.swift
//  Vastar
//
//  Created by Charles Kuo on 2025/6/15.
//

import Foundation

struct KeychainConfiguration {
    static let serviceName = Bundle.main.bundleIdentifier ?? ""
    static let accessGroup: String? = nil
}
