//
//  Core.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/5/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class Core {
    
    static var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: TOKEN_KEYCHAIN_KEY)
        }
        set {
            if let tmpNewValue = newValue {
                KeychainWrapper.standard.set(tmpNewValue, forKey: TOKEN_KEYCHAIN_KEY)
            }
        }
    }
    
}
