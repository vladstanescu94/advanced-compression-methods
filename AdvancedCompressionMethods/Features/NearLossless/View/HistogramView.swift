import SwiftUI
import Charts

struct HistogramView: NSViewRepresentable {
    let entries: [BarChartDataEntry]
    
    func makeNSView(context: Context) -> BarChartView {
        return BarChartView()
    }
    
    func updateNSView(_ nsView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entries)
        formatDataSet(dataSet: dataSet)
        formatLeftAxis(leftAxis: nsView.leftAxis)
        formatXAxis(XAxis: nsView.xAxis)
        nsView.noDataText = "No Data"
        nsView.data = BarChartData(dataSet: dataSet)
        nsView.rightAxis.enabled = false
        nsView.autoScaleMinMaxEnabled = false
        
    }
    
    func formatDataSet(dataSet: BarChartDataSet) {
        dataSet.colors = [.blue]
        dataSet.label = "Histogram"
        dataSet.drawValuesEnabled = false
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(XAxis: XAxis) {
        XAxis.labelPosition = .bottom
        XAxis.axisMinimum = -255;
        XAxis.axisMaximum = 255;
    }
}
