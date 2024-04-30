//
//  chartTab.swift
//  assignment_4
//
//  Created by Ruturaj Chintawar on 4/29/24.
//

import Foundation
import SwiftUI

struct ChartTabView: View {
    var body: some View {
        TabView {
            // First tab with the hourly price variation
            StockHourlyPriceVariationView(stockTicker: "AAPL", xAxisCategories: [], data: [], color: "green")
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Hourly Variation")
            }

            // Second tab with historical OHLC and volume chart
            StockHistoricalOHLCVolumeChartView(stockTicker: "AAPL", xAxisCategories: [], ohlcData: [], volumeData: [])
            .tabItem {
                Image(systemName: "chart.bar.xaxis")
                Text("Historical Chart")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChartTabView()
    }
}
