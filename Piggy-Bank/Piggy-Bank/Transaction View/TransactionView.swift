//
//  TransactionView.swift
//  Piggy-Bank
//
//  Created by Hui on 7/9/24.
//

import SwiftUI

struct TransactionView: View {
    @State private var currentDate: Date = .init()
    @State private var weekSliders: [[Date.WeekDay]] = []
    @State private var selectedTabViewIndex: Int = 1
    @State private var selectedDate: Date = .init()
    @State private var shouldCreateWeek: Bool = false
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView()
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            if weekSliders.isEmpty {
                weekSliders.append(selectedDate.getAllDatesInPreviousWeek())
                weekSliders.append(selectedDate.getAllDatesInWeek())
                weekSliders.append(selectedDate.getAllDatesInNextWeek())
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 5) {
                    Text(selectedDate.format("LLLL"))
                        .foregroundStyle(.coral)
                    Text(selectedDate.format("yyyy"))
                        .foregroundStyle(.greyBackground)
                }
                .font(.title.bold())
                Text(selectedDate.formatted(date: .complete, time: .omitted))
                    .foregroundStyle(.greyBackground)
                    .font(.callout.bold())
            }
            .overlay(content: {
                DatePicker("Due Date", selection: $selectedDate, displayedComponents: .date)
                            .labelsHidden()
                            .allowsHitTesting(true)
                            .opacity(0.0101)
            })
            
            TabView(selection: $selectedTabViewIndex, content: {
                ForEach(weekSliders.indices, id: \.self) { weekIndex in
                    let week = weekSliders[weekIndex]
                    WeekView(week: week)
                        .padding(15)
                        .tag(weekIndex)
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, -15)
            .frame(height: 90)
            .onChange(of: selectedTabViewIndex, initial: false) { oldValue, newValue in
                if newValue == 0 || newValue == weekSliders.count - 1 {
                    shouldCreateWeek = true
                }
            }
            .onChange(of: selectedDate, initial: false) { oldValue, newValue in
                updateWeekSliders(from: newValue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading) // show the position in the parent view
        .padding(15)
    }
   
    @ViewBuilder
    func WeekView(week: [Date.WeekDay]) -> some View {
        HStack() {
            ForEach(week) { day in
                VStack(spacing: 10) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundStyle(day.date.isTheSameDay(with: selectedDate) ? .white : .gray)
                        .background{
                            if day.date.isTheSameDay(with: selectedDate) {
                                Circle()
                                    .fill(.coral)
                                    .frame(width: 30, height: 30)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                        }
                        .background {
                            Circle()
                                .strokeBorder(.greyBackground, lineWidth: 1)
                                .background(Circle().foregroundColor(.clear))
                                .frame(width: 30, height: 30)
                        }
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selectedDate = day.date
                    }
                }
                .background {
                    GeometryReader { proxy in
                        let minX = proxy.frame(in: .global).minX
                        Color.clear
                            .preference(key: OffsetKey.self, value: minX)
                            .onPreferenceChange(OffsetKey.self) { value in
                                loadWeekSliderInAdvance(tabViewEdge: value, createWeek: shouldCreateWeek)
                            }
                    }
                }
            }
        }
    }
    
    private func loadWeekSliderInAdvance(tabViewEdge: CGFloat, createWeek: Bool) {
        if tabViewEdge.rounded() == 15 && createWeek {
            if weekSliders.indices.contains(selectedTabViewIndex) {
                if let firstDate = weekSliders[selectedTabViewIndex].first?.date {
                    if selectedTabViewIndex == 0 {
                        /// Inserting new week at oth index and remove the last array item
                        weekSliders.insert(firstDate.getAllDatesInPreviousWeek(), at: 0)
                        weekSliders.removeLast()
                        selectedTabViewIndex = 1
                    }
                    
                    if selectedTabViewIndex == (weekSliders.count - 1) {
                        /// Inserting new week at nth index and remove the first array item
                        weekSliders.append(firstDate.getAllDatesInNextWeek())
                        weekSliders.removeFirst()
                        selectedTabViewIndex = weekSliders.count - 2
                    }
                }
            }
        }
    }
    
    private func updateWeekSliders(from selectedDate: Date) {
        weekSliders.removeAll()
        weekSliders.append(selectedDate.getAllDatesInPreviousWeek())
        weekSliders.append(selectedDate.getAllDatesInWeek())
        weekSliders.append(selectedDate.getAllDatesInNextWeek())
        shouldCreateWeek = false
    }
}
