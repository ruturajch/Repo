//
//  StockHistoricalOHLCVolumeChartView.swift
//  assignment_4
//
//  Created by Ruturaj Chintawar on 4/29/24.
//

import Foundation
import SwiftUI
import WebKit

struct StockHistoricalOHLCVolumeChartView: View {
    var stockTicker: String
    var xAxisCategories: [String]
    var ohlcData: [Any]
    var volumeData:[Any]
    
    @State private var zoomScale: CGFloat = 1.0
    
    var highchartsHTML: String {
        """
        <html>
        <head>
                <script src="https://code.highcharts.com/stock/highstock.js"></script>
                <script src="https://code.highcharts.com/stock/modules/drag-panes.js"></script>
                <script src="https://code.highcharts.com/stock/modules/exporting.js"></script>
                <script src="https://code.highcharts.com/stock/indicators/indicators.js"></script>
                <script src="https://code.highcharts.com/stock/indicators/volume-by-price.js"></script>
                <script src="https://code.highcharts.com/modules/accessibility.js"></script>
        </head>
        <body>
            <div id="chart-container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
            
            <script>
                Highcharts.chart('chart-container', {
        
                    rangeSelector: {
                        buttons: [{
                            type: 'month',
                            count: 1,
                            text: 'View 1 month'
                        }, {
                            type: 'month',
                            count: 3,
                            text: 'View 3 months'
                        }, {
                            type: 'month',
                            count: 6,
                            text: 'View 6 months'
                        }, {
                            type: 'ytd',
                            text: 'View year to date'
                        }, {
                            type: 'year',
                            count: 1,
                            text: 'View 1 year'
                        }, {
                            type: 'all',
                            text: 'View all'
                        }],
                        selected: 1,
                        inputEnabled: true,
                        dropdown: 'always'
                    },

                    title: {
                        text: 'AAPL Historical',
                        style: {
                            fontSize: '40px'
                        }
                    },

                    subtitle: {
                        text: 'With SMA and Volume by Price technical indicators',
                        style: {
                            fontSize: '30px'
                        }
                    },
                    navigator: {
                        enabled: true
                    },
                    yAxis: [{
                        startOnTick: false,
                        endOnTick: false,
                        labels: {
                            align: 'right',
                            x: -3,
                            style: {
                                fontSize: '30px'
                            }
                        },
                        title: {
                            text: 'OHLC',
                            style: {
                                fontSize: '20px'
                            }
                        },
                        height: '60%',
                        lineWidth: 2,
                        resize: {
                            enabled: true
                        },
                        opposite: true
                    }, {
                        labels: {
                            align: 'right',
                            x: -3,
                            style: {
                                fontSize: '30px'
                            }
                        },
                        title: {
                            text: 'Volume',
                            style: {
                                fontSize: '20px'
                            }
                        },
                        top: '65%',
                        height: '35%',
                        offset: 0,
                        lineWidth: 2,
                        opposite: true
                    }],

                    tooltip: {
                        split: true,
                    },

                    plotOptions: {
                        series: {
                            dataGrouping: {
                                units: [[
                                    'week',
                                    [1]
                                ], [
                                    'month',
                                    [1, 2, 3, 4, 6]
                                ]]
                            }
                        }
                    },

                    series: [{
                        type: 'candlestick',
                        name: 'AAPL',
                        id: 'aapl',
                        zIndex: 2,
                        data: \(ohlcData)
                    }, {
                        type: 'column',
                        name: 'Volume',
                        id: 'volume',
                        data: \(volumeData),
                        yAxis: 1
                    }, {
                        type: 'vbp',
                        linkedTo: 'aapl',
                        params: {
                            volumeSeriesID: 'volume'
                        },
                        dataLabels: {
                            enabled: false
                        },
                        zoneLines: {
                            enabled: false
                        }
                    }, {
                        type: 'sma',
                        linkedTo: 'aapl',
                        zIndex: 1,
                        marker: {
                            enabled: false
                        }
                    }]
                });
            </script>
        </body>
        </html>
        """
    }

    var body: some View {
        HighchartsView(htmlContent: highchartsHTML)
                .scaleEffect(zoomScale)
                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
        
    }
}


#Preview {
    StockHistoricalOHLCVolumeChartView(stockTicker: "AAPL", xAxisCategories: ["2022-04-27","2022-04-28",
        "2022-05-01","2022-05-02",
        "2022-05-03","2022-05-04",
        "2022-05-05","2022-05-08",
        "2022-05-09","2022-05-10",
        "2022-05-11","2022-05-12",
        "2022-05-15","2022-05-16",
        "2022-05-17","2022-05-18",
        "2022-05-19","2022-05-22",
        "2022-05-23","2022-05-24"], ohlcData: [
        ["2022-04-27",159.25,164.51,158.93,163.64],["2022-04-28",161.84,166.2,157.25,157.65],
        ["2022-05-01",156.71,158.23,153.27,157.96],["2022-05-02",158.15,160.71,156.32,159.48],
        ["2022-05-03",159.67,166.48,159.26,166.02],["2022-05-04",163.85,164.08,154.95,156.77],
        ["2022-05-05",156.01,159.44,154.18,157.28],["2022-05-08",154.93,155.83,151.49,152.06],
        ["2022-05-09",155.52,156.74,152.93,154.51],["2022-05-10",153.5,155.45,145.81,146.5],
        ["2022-05-11",142.77,146.2,138.8,142.56],["2022-05-12",144.59,148.1,143.11,147.11],
        ["2022-05-15",145.55,147.52,144.18,145.54],["2022-05-16",148.86,149.77,146.68,149.24],
        ["2022-05-17",146.85,147.36,139.9,140.82],["2022-05-18",139.88,141.66,136.6,137.35],
        ["2022-05-19",139.09,140.7,132.61,137.59],["2022-05-22",137.79,143.26,137.65,143.11],
        ["2022-05-23",140.81,141.97,137.33,140.36],["2022-05-24",138.43,141.78,138.34,140.52]], volumeData: [["2022-04-27",130149192],["2022-04-28",131747495],
                                                                                                             ["2022-05-01",123050000],["2022-05-02",88966526],
                                                                                                             ["2022-05-03",108206503],["2022-05-04",130419230],
                                                                                                             ["2022-05-05",115494647],["2022-05-08",131577921],
                                                                                                             ["2022-05-09",115366736],["2022-05-10",142547625],
                                                                                                             ["2022-05-11",182408091],["2022-05-12",113990852],
                                                                                                             ["2022-05-15",86643781],["2022-05-16",78138254],
                                                                                                             ["2022-05-17",109742890],["2022-05-18",135863540],
                                                                                                             ["2022-05-19",137392625],["2022-05-22",117726265],
                                                                                                             ["2022-05-23",104132746],["2022-05-24",92482696]])
//    StockHistoricalOHLCVolumeChartView(stockTicker: "AAPL", xAxisCategories: ["2022-04", "2022-04", "2022-05", "2022-05"], ohlcData: [["2022-04", 159.25, 164.51, 158.93, 163.64], ["2022-04", 161.84, 166.2, 157.25, 157.65], ["2022-05", 156.71, 158.23, 153.27, 157.96], ["2022-05", 158.15, 160.71, 156.32, 159.48]], volumeData: [["2022-04", 1.3014919e+08], ["2022-04", 1.31747496e+08], ["2022-05", 1.2305e+08], ["2022-05", 8.896653e+07]], groupingUnite: [["week", [1]],["month", [1, 2, 3, 4, 6]]])
}
                                       
        

//["2022-04-27","2022-04-28","2022-05-01","2022-05-02"]
//[["2022-04-27",159.25,164.51,158.93,163.64],["2022-04-28",161.84,166.2,157.25,157.65],["2022-05-01",156.71,158.23,153.27,157.96],["2022-05-02",158.15,160.71,156.32,159.48]]
//[["2022-04-27",130149192],["2022-04-28",131747495],["2022-05-01",123050000],["2022-05-02",88966526]]
//[['week', [1]],['month', [1, 2, 3, 4, 6]]]
