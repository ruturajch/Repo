//
//  StockDetailDataModel.swift
//  assignment_4
//
//  Created by Karthik Patel on 4/19/24.
//

import Foundation

struct StockDetailDataModel: Codable, Hashable {
    var hourlyPriceVariationData: hourlyPriceVariationData
    let historicalChartData: [historicalChartData]
    var portFolioData: portFolioData
    var statsAboutSectionData: statsAboutSectionData
    var insightsData: insightsData
    var newsData: [newsData]
    var currentPortFolioData: GetCurrentPortFolioData
    var watchlistFlag: Bool
}

struct newsData: Codable, Hashable {
    var source: String
    var datetime: Int
    var image: String
    var headline: String
    var summary: String
    var url: String
}

struct hourlyPriceVariationData: Codable, Hashable {
    var datetime: [String]
    var value: [Float]
}

struct historicalChartData: Codable, Hashable {
    let v: Int
    let vw: Float
    let o: Float
    let c: Float
    let h: Float
    let l: Float
    let t: String
    let n: Int
}

struct portFolioData: Codable, Hashable {
    var stockBroughtFlag: Bool
    var stocksOwnedQuantity: Int
    var AvgCostPerShare: String
    var TotalCost: String
    var Change: String
    var MarketValue: String
    var CurrentPrice: String
    var changeInPrice: String
    var changeInPricePercent: String
}

struct statsAboutSectionData: Codable, Hashable {
    var highPrice: String
    var lowprice: String
    var openprice: String
    var prevclose: String
    var ipostartdate: String
    var webpage: String
    var companypeers: [String]
    var industry: String
}

struct insightsData: Codable, Hashable {
    var companyName: String
    var MSPRTotal: String
    var MSPRPositive: String
    var MSPRNegative: String
    var ChangeTotal: String
    var ChangePositive: String
    var ChangeNegative: String
    var RecommendationTrends: [RecommendationTrendsData]
    var historicalEPSSurprises: [historicalEPSSurprisesData]
}

struct RecommendationTrendsData: Codable, Hashable {
    let buy: Int
    let hold: Int
    let period: String
    let sell: Int
    let strongBuy: Int
    let strongSell: Int
    let symbol: String
}

struct historicalEPSSurprisesData: Codable, Hashable {
    let actual: Float
    let estimate: Float
    let period: String
    let quarter: Int
    let surprise: Float
    let surprisePercent: Float
    let symbol: String
    let year: Int
}

struct GetDataSummaryModel: Codable, Hashable {
    let highPrice: Double
    let lowPrice: Double
    let openPrice: Double
    let prevClose: Double
    let ipoStartDate: String
    let webpage: String
    let companyPeers: [String]
    let industry: String
    let hourlyPriceVariationData: hourlyPriceVariationData
}

struct GetDataCurrentPortfolioModel: Codable, Hashable {
    let quantity: Int
    let averageCost: Double
    let totalCost: Double
    let change: Double
    let currentPrice: Double
    let marketValue: Double
    let ticker: String
    let companyName: String
    let stockBroughtFlag: Bool
    
}

struct GetDataItemDaraModal: Codable, Hashable{
    let companyName: String
    let change: Double
    let changePercentage: Double
    let lastPrice: Double
}
struct GetCurrentPortFolioData: Codable, Hashable{
    var currentPrice: Double
    var currentQuantity: Double
    var totalSpend: Double
}
struct GetCompanyInsightsData: Codable, Hashable{
    var totalMSPR: Double
    var positiveMSPR: Double
    var negativeMSPR: Double
    var totalChange: Double
    var positiveChange: Double
    var negativeChange: Double
}
struct ErrorMessage: Codable, Hashable {
    let message: String
}
