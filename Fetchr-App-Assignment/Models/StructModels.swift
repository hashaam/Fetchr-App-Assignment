//
//  StructModels.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/7/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import Foundation

struct ParseHashTag {
    var text: String?
    var indexStart: Int?
    var indexEnd: Int?
    
    init(data: [String: Any]) {
        text = data["text"] as? String
        let indices = data["indices"] as? [Int] ?? []
        if indices.count == 2 {
            indexStart = indices[0]
            indexEnd = indices[1]
        }
    }
}

struct ParseUserMention {
    var text: String?
    var indexStart: Int?
    var indexEnd: Int?
    
    init(data: [String: Any]) {
        text = data["screen_name"] as? String
        let indices = data["indices"] as? [Int] ?? []
        if indices.count == 2 {
            indexStart = indices[0]
            indexEnd = indices[1]
        }
    }
}

struct ParseStatus {
    var text: String?
    var hashTags: [ParseHashTag]?
    var userMentions: [ParseUserMention]?
    
    var isSearchable: Bool {
        return (hashTags?.count ?? 0) > 0 || (userMentions?.count ?? 0) > 0
    }
    
    init(data: [String: Any]) {
        text = data["text"] as? String
        
        let entities = data["entities"] as? [String: Any] ?? [:]
        let hashTagsData = entities["hashtags"] as? [[String: Any]] ?? [[:]]
        let userMentionsData = entities["user_mentions"] as? [[String: Any]] ?? [[:]]
        
        hashTags = hashTagsData.flatMap { hashTag in
            ParseHashTag(data: hashTag)
        }
        
        userMentions = userMentionsData.flatMap { userMentionData in
            ParseUserMention(data: userMentionData)
        }
        
    }
}
