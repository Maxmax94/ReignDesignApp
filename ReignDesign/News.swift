//
//  News.swift
//  ReignDesign
//
//  Created by Delapille on 01/09/2017.
//  Copyright © 2017 Delapille. All rights reserved.
//


import Foundation
import ObjectMapper

public class News: Mappable {
    
    var storyTitle: String?
    var author: String?
    var createdDate: String?
    var webViewUrl: String?
    
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        storyTitle <- map["story_title"]
        author <- map["author"]
        createdDate <- map["created_at"]
        webViewUrl <- map["story_url"]
        
    }
}

public class JsonNews: Mappable {
    
    var hits: [News]?
    var pages: Int?
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        hits <- map["hits"]
        pages <- map["nbPages"]
    }
}
