//
//  NewTask.swift
//  Task Up
//
//  Created by Yashas Kantharaj on 5/7/24.
//

import SwiftUI
import SwiftData

struct NewTask: View {
    @Environment(\.dismiss) var dismiss
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor: String = "Color 1"
    @State private var taskCaption: String = ""
    @State private var alert = false
    private var task: Task?
    private var isUpdate = false
    
    
    @Environment(\.modelContext) private var context
    
    init(task: Task? = nil) {
        self.task = task
        self.isUpdate = self.task != nil
    }
    
    var body: some View {
        VStack(alignment: .leading, content: {
            VStack(alignment: .leading, content: {
                Label(isUpdate ? "Update Task" : "Add New Task", systemImage: "arrow.left")
                    .onTapGesture {
                        dismiss()
                    }
                VStack(spacing: 20, content: {
                    TextField("Task Title", text: $taskTitle)
                })
                .padding(.top)
            })
            .hSpacing(.leading)
            .padding(30)
            .frame(maxWidth: .infinity)
            .background {
                Rectangle().fill(.gray.opacity(0.2))
                    .clipShape(.rect(bottomLeadingRadius: 30, bottomTrailingRadius: 30))
                    .ignoresSafeArea()
            }
            
            // Task Title
            VStack(alignment: .leading, spacing: 30, content: {
                VStack(spacing: 20, content: {
                    TextField("Task Caption", text: $taskCaption)
                    Divider()
                })
                
                VStack(alignment: .leading, spacing: 20, content: {
                    Text("Timeline")
                        .font(.title3)
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                })
                
                VStack(alignment: .leading, spacing: 20, content: {
                    Text("Task Color")
                        .font(.title3)
                    
                    let colors: [String] = (1...7).compactMap { index -> String in
                        return "Color \(index)"
                    }
                    
                    HStack(spacing: 10, content: {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(color).opacity(0.4))
                                .background {
                                    Circle().stroke(lineWidth: 2)
                                        .opacity(taskColor == color ? 1 : 0)
                                }
                                .hSpacing(.center)
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        taskColor = color
                                    }
                                }
                        }
                    })
                })
            })
            .padding(30)
            .vSpacing(.top)
            
            Button {
                guard !taskTitle.isEmpty, !taskCaption.isEmpty else {
                    alert = true
                    return
                }
                if isUpdate {
                    task?.title = taskTitle
                    task?.caption = taskCaption
                    task?.date = taskDate
                    task?.tint = taskColor
                } else {
                    let task = Task(title: taskTitle, caption: taskCaption, date: taskDate, tint: taskColor)
                    context.insert(task)
                }
                do {
                    try context.save()
                    dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Text(isUpdate ? "Update Task" : "Create Task")
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(.black)
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal, 30)
            }
            .alert(isPresented: $alert) {
                Alert(title: Text("Task"), message: Text("Please add your Task's Title and Caption"), dismissButton: .cancel())
            }
        })
        .vSpacing(.top)
        .onAppear {
            if let task = task, isUpdate {
                taskTitle = task.title
                taskCaption = task.caption
                taskDate = task.date
                taskColor = task.tint
            }
        }
    }
}

#Preview {
    NewTask()
}
