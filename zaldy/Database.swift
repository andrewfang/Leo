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
        "Not yet": ChatConvo(ai: "When are you free? I can remind you then so you'll remember to do your exercises!", user: ["Set a reminder", "Not now"]),
        "Get a tip": ChatConvo(ai: Database.getRandomTip(), user: ["I see"]),
        "Check in": ChatConvo(ai: "Have you done your exercises for today?", user:["Yes!", "Not yet"]),
        "Thanks": ChatConvo(ai: "Have you done your exercises for today?", user: ["Update log", "Remind me later"])
    ]
    
    static func getResponseTo(message: String) -> ChatConvo {
        return responses[message] ?? ChatConvo(ai: "That's it for today!", user: [])
    }
    
    static var didDoExercisesToday = [false, false, false]
    
    static var exercises: [[String]] = [
        ["Doorway stretch (10 seconds)", "External rotation (1 set of 10)", "Reverse fly (1 set of 10)"],
        ["Doorway stretch (20 seconds)", "External rotation (2 sets of 10)", "Reverse fly (2 sets of 10)"],
        ["Doorway stretch (30 seconds)", "External rotation (3 sets of 10)", "Reverse fly (3 sets of 10)"],
        ["Plank (2 sets of 20 seconds)", "External rotation (3 sets of 15)", "Reverse fly (3 sets of 10)"],
        ["Plank (3 sets of 20 seconds)", "External rotation (3 sets of 20)", "I's and W's (2 sets of 10)"],
        ["Plank (4 sets of 20 seconds)", "External rotation (3 sets of 25)", "I's and W's (3 sets of 10)"],
        ["Plank (3 sets of 30 seconds)", "High to Low Rows (3 sets of 10)" , "I's and W's (3 sets of 15)"],
        ["Plank (4 sets of 30 seconds)", "High to Low Rows (3 sets of 10)" , "I's and W's (3 sets of 15)"],
        ["Plank (4 sets of 40 seconds)", "High to Low Rows (4 sets of 10)" , "Plank Push-ups (1 set of 10)"],
        ["Plank (5 sets of 40 seconds)", "High to Low Rows (4 sets of 10)" , "Plank Push-ups (2 sets of 10)"],
        ["Superman (3 sets of 10)"     , "High to Low Rows (4 sets of 15)" , "Plank Push-ups (2 sets of 15)"],
        ["Superman (4 sets of 10)"     , "High to Low Rows (4 sets of 15)" , "Plank Push-ups (2 sets of 15)"],
        ["Superman (4 sets of 15)"     , "High to Low Rows (5 sets of 15)" , "Plank Push-ups (3 sets of 15)"],
    ]
}

struct ChatConvo {
    var ai:String!
    var user:[String]!
    var freeResponse:Bool
    var freeResponseHint: String!
    
    init(ai:String, user:[String]) {
        self.ai = ai
        self.user = user
        self.freeResponse = false
        self.freeResponseHint = ""
    }
    
    init(ai:String, freeResponseHint:String) {
        self.ai = ai
        self.user = []
        self.freeResponse = true
        self.freeResponseHint = freeResponseHint
    }
}