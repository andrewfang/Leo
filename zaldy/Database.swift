//
//  Database.swift
//  zaldy
//
//  Created by Andrew Fang on 2/23/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import Foundation
struct Database {
 
    
    struct HtmlTip {
        var tip:String!
        var url:String?
        
        init(_ tip:String) {
            self.tip = tip
        }
        
        init(_ tip:String, _ url:String) {
            self.tip = tip
            self.url = url
        }
    }
    
    
    static let tips:[String] = [
        "PT is good for you",
        "Do PT every day otherwise your joints will freeze",
    ]
    
    static func getRandomTip() -> String {
        let idx = Int(arc4random_uniform(UInt32(tips.count)))
        return tips[idx]
    }
    
    
    static let responses:[String:ChatConvo] = [
        "Yes!": ChatConvo(ai: "Can you show me?", user: ["Here's a photo!", "Not now"]),
        "Not yet": ChatConvo(ai: Database.getRandomTip(), user: ["OK"])
    ]
    
    static func getResponseTo(message: String) -> ChatConvo {
        return responses[message] ?? ChatConvo(ai: "What else do you want to do!", user: ["Check in", "Get a tip"])
    }
}

struct ChatConvo {
    var ai:String!
    var user:[String]!
    
    init(ai:String, user:[String]) {
        self.ai = ai
        self.user = user
    }
}