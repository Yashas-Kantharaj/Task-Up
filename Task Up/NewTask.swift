//
//  NewTask.swift
//  Task Up
//
//  Created by Yashas Kantharaj on 5/7/24.
//

import SwiftUI

struct NewTask: View {
    @Environment(\.dismiss) var dismiss
    @State private var tastTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor: Color = .purple
    
    
    var body: some View {
        VStack(alignment: .leading, content: {
            VStack(alignment: .leading, content: {
                Label("Add New Task", systemImage: "arrow.left")
                    .onTapGesture {
                        dismiss()
                    }
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
                    TextField("Task Title", text: $tastTitle)
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
                    
                    let colors: [Color] = [.yellow, .purple, .green, .red, .blue, .gray]
                    
                    HStack(spacing: 10, content: {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color.opacity(0.2))
                                .hSpacing(.center)
                        }
                    })
                })
            })
            .padding(30)
            .vSpacing(.top)
            
            Button {
                
            } label: {
                Text("Create Task")
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(.black)
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal, 30)
            }
        })
        .vSpacing(.top)
    }
}

#Preview {
    NewTask()
}
