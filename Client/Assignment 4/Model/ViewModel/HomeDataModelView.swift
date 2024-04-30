//
//  HomeDataModelView.swift
//  assignment_4
//
//  Created by Karthik Patel on 4/12/24.
//

import SwiftUI
import Foundation

class HomeDataModelView: ObservableObject {
    @Published var date: String
    @Published var walletMoney: String = "0.00"
    @Published var netWorth: String = "0.00"
    @Published var portfolioDataFlag: Bool = false
    @Published var portFolioData: [PortfolioDataModel] = []
    @Published var watchListFlag: Bool = false
    @Published var watchListData: [WatchListData] = []
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        self.date = dateFormatter.string(from: Date())
        getData()
    }
    
    private func getData() {
        APIService.instance.callInternalGetAPI(endpoint: "/api/getAllPortfolios", completion: {
            data in
            if data != nil {
                guard let res: GetDataHomeDataModel = data?.parseTo() else { print("No Data"); return }
                self.walletMoney = String(format: "%.2f", res.moneyInWallet)
                self.netWorth = String(format: "%.2f", res.netWorth)
                self.portfolioDataFlag = false
                for dataModel in res.requestedData {
                    self.portfolioDataFlag = true
                    let tickerValue = dataModel.ticker
                    let marketValue = String(format: "%.2f", dataModel.marketValue)
                    let changeInPriceFromTotalCost = String(format: "%.2f", dataModel.change)
                    let changeInPriceFromTotalCostPercent = String(format: "%.2f", (dataModel.change / dataModel.totalCost) * 100)
                    let quantity = dataModel.quantity
                    
                    let portfolioDataModel = PortfolioDataModel(tickerValue: tickerValue,
                                                                marketValue: marketValue,
                                                                changeInPriceFromTotalCost: changeInPriceFromTotalCost,
                                                                changeInPriceFromTotalCostPercent: changeInPriceFromTotalCostPercent,
                                                                quantity: quantity)
                    
                    self.portFolioData.append(portfolioDataModel)
                }
            } else {
                print("failure")
            }
        })
        APIService.instance.callInternalGetAPI(endpoint: "/api/getWatchlistData", completion: {
            data in
            if data != nil {
                guard let res: [GetDataWatchListData] = data?.parseTo() else { print("No Data"); return }
                self.watchListFlag = false
                for dataModel in res {
                    self.watchListFlag = true
                    let ticker = dataModel.ticker
                    let companyName = dataModel.companyName
                    let lastPrice = String(format: "%.2f", dataModel.lastPrice)
                    let change = String(format: "%.2f", (dataModel.change))
                    let changePercentage = String(format: "%.2f", (dataModel.changePercentage))
                    let watchListDataModel = WatchListData(stockSymbol: ticker,
                                                                  stockName: companyName,
                                                                  currentPrice: lastPrice,
                                                                  changeInPrice: change,
                                                                  changeInPricePercent: changePercentage)
                    
                    self.watchListData.append(watchListDataModel)
                }
            } else {
                print("failure")
            }
        })
    }
}
