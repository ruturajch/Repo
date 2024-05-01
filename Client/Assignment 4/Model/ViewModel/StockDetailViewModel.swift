//
//  StockDetailViewModel.swift
//  assignment_4
//
//  Created by Karthik Patel on 4/20/24.
//

import SwiftUI
import Foundation

class StockDetailViewModel: ObservableObject {
    @Published var stockDetailData: StockDetailDataModel = StockDetailDataModel(
        hourlyPriceVariationData: hourlyPriceVariationData(
            datetime:[],
            value:[]
        ),
        historicalChartData: [],
        portFolioData: portFolioData(
            stockBroughtFlag: false,
            stocksOwnedQuantity: 0,
            AvgCostPerShare: "",
            TotalCost: "",
            Change: "",
            MarketValue: "",
            CurrentPrice: "",
            changeInPrice: "",
            changeInPricePercent: ""
        ),
        statsAboutSectionData: statsAboutSectionData(
            highPrice: "0.0",
            lowprice: "0.0",
            openprice: "0.0",
            prevclose: "0.0",
            ipostartdate: "",
            webpage: "",
            companypeers: [],
            industry: ""
        ),
        insightsData: insightsData(
            companyName: "",
            MSPRTotal: "0.0",
            MSPRPositive: "0.0",
            MSPRNegative: "0.0",
            ChangeTotal: "0.0",
            ChangePositive: "0.0",
            ChangeNegative: "0.0",
            RecommendationTrends: [],
            historicalEPSSurprises: []
        ),
        newsData: [],
        currentPortFolioData:GetCurrentPortFolioData(
            currentPrice: 0,
            currentQuantity: 0,
            totalSpend: 0
        ),
        watchlistFlag: false
    )
    
    @Published var firstNewsArticle: newsData = newsData(
        source: "",
        datetime: 0,
        image: "",
        headline: "",
        summary: "",
        url: ""
    )
    @Published var historicalChartDataXAxisCategories:[String] = []
    @Published var historicalChartDataOHLC = []
    @Published var historicalChartDataVolume = []
    
    init(tickerSymbol: String) {
        print(tickerSymbol)
        var endpoint = "/api/getSummaryData?ticker="+tickerSymbol
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: GetDataSummaryModel = data?.parseTo() else { print("No Data"); return }
                self.stockDetailData.statsAboutSectionData.highPrice = String(format: "%.2f", res.highPrice)
                self.stockDetailData.statsAboutSectionData.lowprice = String(format: "%.2f", res.lowPrice)
                self.stockDetailData.statsAboutSectionData.openprice = String(format: "%.2f", res.openPrice)
                self.stockDetailData.statsAboutSectionData.prevclose = String(format: "%.2f", res.prevClose)
                self.stockDetailData.statsAboutSectionData.ipostartdate = res.ipoStartDate
                self.stockDetailData.statsAboutSectionData.companypeers = res.companyPeers
                self.stockDetailData.statsAboutSectionData.industry = res.industry
                self.stockDetailData.statsAboutSectionData.webpage = res.webpage
                self.stockDetailData.hourlyPriceVariationData = res.hourlyPriceVariationData
            }
        })
        endpoint = "/api/getPortfolioAllData?ticker="+tickerSymbol
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: GetDataCurrentPortfolioModel = data?.parseTo() else { print("No Data"); return }
                self.stockDetailData.portFolioData.stockBroughtFlag = res.stockBroughtFlag
                self.stockDetailData.portFolioData.stocksOwnedQuantity = res.quantity
                self.stockDetailData.portFolioData.AvgCostPerShare = String(format: "%.2f", res.averageCost)
                self.stockDetailData.portFolioData.TotalCost = String(format: "%.2f", res.totalCost)
                self.stockDetailData.portFolioData.Change = String(format: "%.2f", res.change)
                self.stockDetailData.portFolioData.MarketValue = String(format: "%.2f", res.marketValue)
                self.stockDetailData.portFolioData.CurrentPrice = String(format: "%.2f", res.marketValue)
                
            }
        })
        endpoint = "/api/getItems?ticker="+tickerSymbol
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: GetDataItemDaraModal = data?.parseTo() else { print("No Data"); return }
                self.stockDetailData.insightsData.companyName = res.companyName
                self.stockDetailData.portFolioData.changeInPrice = String(format: "%.2f", res.change)
                self.stockDetailData.portFolioData.changeInPricePercent = String(format: "%.2f", res.changePercentage)
            }
        })
        endpoint = "/api/getCurrentPortfolio?ticker="+tickerSymbol
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: GetCurrentPortFolioData = data?.parseTo() else { print("No Data"); return }
                self.stockDetailData.currentPortFolioData = res
            }
        })
        endpoint = "/api/getCompanyInsightData?ticker="+tickerSymbol
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: GetCompanyInsightsData = data?.parseTo() else { print("No Data"); return }
                self.stockDetailData.insightsData.MSPRTotal = String(format: "%.2f", res.totalMSPR)
                self.stockDetailData.insightsData.MSPRPositive = String(format: "%.2f", res.positiveMSPR)
                self.stockDetailData.insightsData.MSPRNegative = String(format: "%.2f", res.negativeMSPR)
                self.stockDetailData.insightsData.ChangeTotal = String(format: "%.2f", res.totalMSPR)
                self.stockDetailData.insightsData.ChangePositive = String(format: "%.2f", res.positiveMSPR)
                self.stockDetailData.insightsData.ChangeNegative = String(format: "%.2f", res.negativeChange)
            }
        })
        endpoint = "/api/getCompanyNewsData?ticker="+tickerSymbol
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: [newsData] = data?.parseTo() else { print("No Data"); return }
                self.firstNewsArticle = res[0]
                self.stockDetailData.newsData = res
                if !self.stockDetailData.newsData.isEmpty {
                    self.stockDetailData.newsData.removeFirst()
                }
                
            }
            
        })
        endpoint = "/api/getWatchlistIspresentData?ticker="+tickerSymbol
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: ErrorMessage = data?.parseTo() else { print("No Data"); return }
                print(res.message)
                if(res.message == "true"){
                    self.stockDetailData.watchlistFlag = true
                }else{
                    self.stockDetailData.watchlistFlag = false
                }
            }
        })
    }
}
