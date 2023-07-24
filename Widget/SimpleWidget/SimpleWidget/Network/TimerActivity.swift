//
//  TimerActivity.swift
//  SimpleWidget
//
//  Created by Shawn Frank on 24/7/2023.
//

import ActivityKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var endTime: Date
    }
    
    var timeName: String
}

