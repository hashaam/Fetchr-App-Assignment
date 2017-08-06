//
//  UserMentionTests.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/7/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import XCTest
@testable import Fetchr_App_Assignment

class UserMentionTests: XCTestCase {
    
    func testUserMention() {
        
        let userMention = ParseUserMention(data: [
            "screen_name": "@userMention",
            "indices": [
                0, 11
            ]
            ])
        
        XCTAssertEqual(userMention.text, "@userMention", "User Mention: text should be same")
        XCTAssertEqual(userMention.indexStart, 0, "User Mention: indexStart should be same")
        XCTAssertEqual(userMention.indexEnd, 11, "User Mention: indexEnd should be same")
        
    }
    
}
