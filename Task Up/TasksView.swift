//
//  TasksView.swift
//  Task Up
//
//  Created by Yashas Kantharaj on 5/7/24.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    
    @Binding var date: Date
    
    @Query private var tasks: [Task]
    init(date: Binding<Date>) {
        self._date = date
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = #Predicate<Task> {
            return $0.date >= startDate && $0.date < endOfDate
        }
        
        let sortDescriptor = [
            SortDescriptor(\Task.date, order: .reverse)
        ]
        self._tasks = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    
    var body: some View {
        VStack(alignment: .leading, content: {
            ForEach(tasks) { task in
                TaskItem(task: task)
            }
        })
        .padding(.top)
        .overlay {
            if tasks.isEmpty {
                Text("No Task's Added")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(width: 150)
                    .offset(y: 10)
            }
        }
    }
}

#Preview {
    ContentView()
}
