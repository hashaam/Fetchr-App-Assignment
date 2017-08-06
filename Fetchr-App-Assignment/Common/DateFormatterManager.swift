//
//  DateFormatterManager.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/7/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import Foundation

class DateFormatterManager {
    
    static var shared = DateFormatterManager()
    
    let formatter: DateFormatter
    
    init() {
        
        formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.timeZone = Calendar.current.timeZone
        
    }
    
}
