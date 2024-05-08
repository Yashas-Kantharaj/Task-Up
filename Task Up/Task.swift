//
//  Task.swift
//  Task Up
//
//  Created by Yashas Kantharaj on 5/7/24.
//

import SwiftUI
import SwiftData

@Model
class Task: Identifiable {
    var id: UUID
    var title: String
    var caption: String
    var date: Date
    var isCompleted: Bool
    var tint: String
    
    init(id: UUID = .init(), title: String, caption: String, date: Date = .init(), isCompleted: Bool = false, tint: String) {
        self.id = id
        self.title = title
        self.caption = caption
        self.date = date
        self.isCompleted = isCompleted
        self.tint = tint
    }
}


extension Data {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
