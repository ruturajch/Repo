//
//  HomeData.swift
//  assignment_4s
//  Created by Ruturaj Chintawar on 4/12/24.
//

import Foundation

struct HomeDataModel: Codable, Hashable {
    let walletMoney: String
    let netWorth: String
    let portfolioDataFlag: Bool
    let portFolioData: [PortfolioDataModel]
    let watchListFlag: Bool
    let watchListData: [WatchListData]
}

struct PortfolioDataModel: Codable, Hashable {
    let tickerValue: String
    let marketValue: String
    let changeInPriceFromTotalCost: String
    let changeInPriceFromTotalCostPercent: String
    let quantity: Int
}

struct WatchListData: Codable, Hashable {
    let stockSymbol: String
    let stockName: String
    let currentPrice: String
    let changeInPrice: String
    let changeInPricePercent: String
}

struct GetDataHomeDataModel: Codable, Hashable {
    let moneyInWallet: Double
    let netWorth: Double
    let requestedData: [GetDataPortfolioDataModel]
}

struct GetDataPortfolioDataModel: Codable, Hashable {
    let ticker: String
    let marketValue: Double
    let change: Double
    let totalCost: Double
    let quantity: Int
}

struct GetDataWatchListData: Codable, Hashable {
    let ticker: String
    let companyName: String
    let lastPrice: Double
    let change: Double
    let changePercentage: Double
}
