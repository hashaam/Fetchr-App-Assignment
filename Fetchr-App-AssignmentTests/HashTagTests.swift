//
//  HashTagTests.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/7/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import XCTest
@testable import Fetchr_App_Assignment

class HashTagTests: XCTestCase {
    
    func testHashTag() {
        
        let hashTag = ParseHashTag(data: [
            "text": "#tag",
            "indices": [
                0, 3
            ]
        ])
        
        XCTAssertEqual(hashTag.text, "#tag", "Hashtag: text should be same")
        XCTAssertEqual(hashTag.indexStart, 0, "Hashtag: indexStart should be same")
        XCTAssertEqual(hashTag.indexEnd, 3, "Hashtag: indexEnd should be same")
        
    }
    
}
