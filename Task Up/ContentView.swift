//
//  ContentView.swift
//  Task Up
//
//  Created by Yashas Kantharaj on 5/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var currentDate: Date = .init()
    
    @State var weekSlider: [[Date.WeekDay]] = []
    @State var currentWeekIndex: Int = 1
    @State var currentMonth: String = ""
    
    @Namespace private var animation
    
    @State private var createWeek: Bool = false
        
    @State private var createNewTask: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content:  {
            VStack(alignment: .leading, content: {
                Text("Calender")
                    .font(.system(size: 36, weight: .semibold))
                
                Text("\(currentMonth)")
                    .fontWeight(.bold)
                    .offset(y: 5)
                
                //Week Slider
                TabView(selection: $currentWeekIndex,
                        content:  {
                    ForEach(weekSlider.indices, id: \.self) { index in
                        let week = weekSlider[index]
                        weekView(week)
                            .tag(index)
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 90)
            })
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                Rectangle().fill(.gray.opacity(0.2))
                    .clipShape(.rect(bottomLeadingRadius: 30, bottomTrailingRadius: 30))
                    .ignoresSafeArea()
            }
            .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
                if newValue == 0 || newValue == (weekSlider.count - 1) {
                    createWeek = true
                }
            }
            
            ScrollView(.vertical) {
                VStack {
                    TasksView(date: $currentDate)
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        })
        .vSpacing(.top)
        .frame(maxWidth: .infinity)
        .onAppear() {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
                getMonth()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                createNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding(25)
                    .background(.black)
                    .clipShape(Circle())
                    .padding([.horizontal])
                    .foregroundColor(.white)
            })
            .fullScreenCover(isPresented: $createNewTask, content: {
                NewTask()
            })
        }
    }
    
    // Week View
    @ViewBuilder
    func weekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.system(size: 20))
                        .frame(width: 50, height: 55)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .black)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.black)
                                    .offset(y: 2)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            if day.date.isToday {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                            }
                        })
                }
                .hSpacing(.center)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: { value in
                        if value.rounded() == 16 && createWeek {
                            getMonth()
                            paginateWeek()
                            createWeek = false
                        }
                    })
            }
        }
    }
    
    func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
    
    func getMonth() {
        if let firstDate = weekSlider[currentWeekIndex].first?.date, let lastDate = weekSlider[currentWeekIndex].last?.date {
            let first = firstDate.format("MMM")
            let last = lastDate.format("MMM")
            currentMonth = first == last ? first : "\(first)-\(last)"
        }
    }
}
#Preview {
    ContentView()
}
