//
//  TasksSwipe.swift
//  Task Up
//
//  Created by Yashas Kantharaj on 5/8/24.
//

import SwiftUI

struct TasksSwipe<Content: View, Left: View, Right: View>: View {
    var content: () -> Content
    var left: () -> Left
    var right: () -> Right
    var onTapLeft: () -> Task?
    var onTapRight: () -> Void
    
    @State var hoffset: CGFloat = 0
    @State var anchor: CGFloat = 0
    @State private var deleteAlert = false
    @State private var showUpdate = false
    
    let screenWidth = UIScreen.main.bounds.width
    var anchorWidth: CGFloat { screenWidth / 6 }
    var swipeThreshold: CGFloat { screenWidth / 15 }
    
    @State var rightPast = false
    @State var leftPast = false
    
    init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder left: @escaping () -> Left, @ViewBuilder right: @escaping () -> Right, onTapLeft: @escaping () -> Task? = { return nil }, onTapRight: @escaping () -> Void = {})
    {
        self.content = content
        self.left = left
        self.right = right
        self.onTapLeft = onTapLeft
        self.onTapRight = onTapRight
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation {
                    hoffset = anchor + value.translation.width
                    
                    if abs(hoffset) > anchorWidth {
                        if leftPast {
                            hoffset = anchorWidth
                        } else if rightPast {
                            hoffset = -anchorWidth
                        }
                    }
                    
                    if anchor > 0 {
                        leftPast = hoffset > anchorWidth - swipeThreshold
                    } else {
                        leftPast = hoffset > swipeThreshold
                    }
                    
                    if anchor < 0 {
                        rightPast = hoffset < -anchorWidth + swipeThreshold
                    } else {
                        rightPast = hoffset < -swipeThreshold
                    }
                }
            }
            .onEnded { value in
                withAnimation {
                    if rightPast {
                        anchor = -anchorWidth
                    } else if leftPast {
                        anchor = anchorWidth
                    } else {
                        anchor = 0
                    }
                    
                    hoffset = anchor
                }
            }
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center,spacing: 0) {
                left()
                    .frame(width: anchorWidth, height: 60)
                    .zIndex(1)
                    .clipped()
                    .onTapGesture {
                        showUpdate.toggle()
                    }
                    .fullScreenCover(isPresented: $showUpdate, 
                                     onDismiss: {
                        withAnimation {
                            hoffset = 0
                        }
                    },
                                     content: {
                        if let task = onTapLeft() {
                            NewTask(task: task)
                        }
                    })
                
                content()
                    .frame(width: geo.size.width)
                    .zIndex(0)
                        
                
                right()
                    .frame(width: anchorWidth, height: 60)
                    .zIndex(1)
                    .clipped()
                    .onTapGesture(perform: {
                        deleteAlert.toggle()
                    })
                    .alert(isPresented: $deleteAlert) {
                        Alert(title: Text("Delete"), message: Text("Do you want to delete the task?"), primaryButton: .destructive(Text("Yes"), action: onTapRight), secondaryButton: .cancel())
                    }
            }
        }
        .offset(x: -anchorWidth + hoffset)
        .contentShape(Rectangle())
        .gesture(drag)
        .clipped()
    }
}
