//
//  StatusTests.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/7/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import XCTest
@testable import Fetchr_App_Assignment

class StatusTests: XCTestCase {
    
    func testStatus() {
        
        let statusText = "RT @S_T_O_P_TERROR: #BREAKING : #Dubai Torch Tower hit by fire again\n#DubaiTorch https://t.co/nyrH2p6ToM"
        
        let statusData: [String: Any] = [
            "text": statusText,
            "entities": [
                "hashtags": [
                    ["text": "BREAKING", "indices": [20, 29]],
                    ["text": "Dubai", "indices": [32, 38]],
                    ["text": "DubaiTorch", "indices": [69, 80]]
                ],
                "user_mentions": [
                    ["screen_name": "S_T_O_P_TERROR", "indices": [3, 18]]
                ]
            ]
        ]
        
        let status = ParseStatus(data: statusData)
        
        XCTAssertEqual(status.text, statusText, "Status: text should be same")
        XCTAssertEqual(status.hashTags?.count, 3, "Status: hashtags count should be same")
        XCTAssertEqual(status.userMentions?.count, 1, "Status: user mentions count should be same")
        
        XCTAssertEqual(status.hashTags?.first?.text, "BREAKING", "Status: hashtag text should be same")
        XCTAssertEqual(status.userMentions?.first?.text, "S_T_O_P_TERROR", "Status: user mention text should be same")
        
    }
    
}
