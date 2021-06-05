//
//  HistogramView.swift
//  AdvancedCompressionMethods
//
//  Created by Vlad Stanescu on 05.06.2021.
//

import SwiftUI
import Charts

struct HistogramView: NSViewRepresentable {
    let entries: [BarChartDataEntry]
    
    func makeNSView(context: Context) -> BarChartView {
        return BarChartView()
    }
    
    func updateNSView(_ nsView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entries)
        nsView.data = BarChartData(dataSet: dataSet)
    }
}
