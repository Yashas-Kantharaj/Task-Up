//
//  Task.swift
//  Task Up
//
//  Created by Yashas Kantharaj on 5/7/24.
//

import SwiftUI

struct Task: Identifiable {
    var id: UUID = .init()
    var title: String
    var caption: String
    var date: Date = .init()
    var isCompleted = false
    var tint: Color
}


var sampleTask: [Task] = [
    .init(title: "t1", caption: "task1", tint: .yellow),
    .init(title: "t2", caption: "task2", tint: .green),
    .init(title: "t3", caption: "task3", tint: .red),
    .init(title: "t4", caption: "task4", tint: .pink),
]

extension Data {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
