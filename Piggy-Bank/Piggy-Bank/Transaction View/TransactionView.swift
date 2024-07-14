//
//  TransactionView.swift
//  Piggy-Bank
//
//  Created by Hui on 7/9/24.
//

import SwiftUI

struct TransactionView: View {
    
    @Namespace private var animation
    @ObservedObject private var interactor: TransactionInteractor = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView()
            ScrollView {
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            interactor.initializeWeekSlider()
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 5) {
                    Text(interactor.selectedDate.format("LLLL"))
                        .foregroundStyle(.coral)
                    Text(interactor.selectedDate.format("yyyy"))
                        .foregroundStyle(.greyBackground)
                }
                .font(.title.bold())
                Text(interactor.selectedDate.formatted(date: .complete, time: .omitted))
                    .foregroundStyle(.greyBackground)
                    .font(.callout.bold())
            }
            .overlay(content: {
                DatePicker("Due Date", selection: $interactor.selectedDate, displayedComponents: .date)
                            .labelsHidden()
                            .allowsHitTesting(true)
                            .opacity(0.0101)
            })
            
            TabView(selection: $interactor.selectedTabViewIndex, content: {
                ForEach(interactor.weekSlider.indices, id: \.self) { weekIndex in
                    let week = interactor.weekSlider[weekIndex]
                    WeekView(week: week)
                        .padding(15)
                        .tag(weekIndex)
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, -15)
            .frame(height: 90)
            .onChange(of: interactor.selectedTabViewIndex, initial: false) { oldValue, newValue in
                if newValue == 0 || newValue == interactor.weekSlider.count - 1 {
                    interactor.shouldCreateWeek = true
                }
            }
            .onChange(of: interactor.selectedDate, initial: false) { oldValue, newValue in
                interactor.updateWeekSliders(from: newValue)
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
                        .foregroundStyle(day.date.isTheSameDay(with: interactor.selectedDate) ? .white : .gray)
                        .background{
                            if day.date.isTheSameDay(with: interactor.selectedDate) {
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
                        interactor.selectedDate = day.date
                    }
                }
                .background {
                    GeometryReader { proxy in
                        let minX = proxy.frame(in: .global).minX
                        Color.clear
                            .preference(key: OffsetKey.self, value: minX)
                            .onPreferenceChange(OffsetKey.self) { value in
                                interactor.loadWeekSliderInAdvance(tabViewEdge: value)
                            }
                    }
                }
            }
        }
    }
    
    
   
}
