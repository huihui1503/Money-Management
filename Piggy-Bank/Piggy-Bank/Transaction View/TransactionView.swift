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
    @State private var selectedTabView: Int = 1
    @State private var selectedDate: Date = .init()
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView()
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            if weekSliders.isEmpty {
                weekSliders.append(currentDate.getAllDatesInWeek())
                weekSliders.append(currentDate.getAllDatesInWeek())
                weekSliders.append(currentDate.getAllDatesInWeek())
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
            
            TabView(selection: $selectedTabView, content: {
                ForEach(weekSliders, id: \.self) { week in
                    WeekView(week: week)
                        .padding(15)
                    
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, -15)
            .frame(height: 90)
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
            }
        }
    }
}
