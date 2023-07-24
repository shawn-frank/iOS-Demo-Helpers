//
//  WidgetModel.swift
//  SimpleWidget
//
//  Created by Shawn Frank on 24/7/2023.
//

import Foundation

struct APIResponse: Decodable {
    let record: Record
}

struct Record: Decodable, Identifiable {
    let category: String
    let id: Int
    let headline: String
    let summary: String
    let image: String
    
    static func placeholder() -> Record {
        Record(category: "", id: 0, headline: "", summary: "", image: "")
    }
}
