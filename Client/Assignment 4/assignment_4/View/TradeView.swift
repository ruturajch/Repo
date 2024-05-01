//
//  TradeView.swift
//  assignment_4
//
//  Created by Ruturaj Chintawar on 4/30/24.
//

import Foundation

import SwiftUI
import Modals
import AlertToast

struct TradeView: View {
    @ObservedObject var stockDetailVM: StockDetailViewModel
    var stockTicker: String
    @State private var presented: Bool = false
    @StateObject private var currentStockData: CurrentPortfolioModel
    
    init(stockDetailVM: StockDetailViewModel, stockTicker: String) {
        self.stockTicker = stockTicker
        self.stockDetailVM = stockDetailVM
        _currentStockData = StateObject(wrappedValue: CurrentPortfolioModel(tickerSymbol: stockTicker))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Portfolio")
                    .font(.title)
                Spacer()
            }
            Spacer()
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    if stockDetailVM.stockDetailData.portFolioData.stockBroughtFlag {
                        Text("Shares Owned: ").bold() + Text("\(stockDetailVM.stockDetailData.portFolioData.stocksOwnedQuantity)")
                        Spacer()
                        Text("Avg. Cost/Share: ").bold() + Text("$\(stockDetailVM.stockDetailData.portFolioData.AvgCostPerShare)")
                        Spacer()
                        Text("Total Cost: ").bold() + Text("$\(stockDetailVM.stockDetailData.portFolioData.TotalCost)")
                        Spacer()
                        Text("Change: ").bold() + Text("$\(stockDetailVM.stockDetailData.portFolioData.Change)")
                        Spacer()
                        Text("Market Value: ").bold() + Text("$\(stockDetailVM.stockDetailData.portFolioData.MarketValue)")
                    } else {
                        Text("You have 0 shares of \(stockTicker).\nStart trading!")
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Button(action: {
                        updateCurrentPortfolio()
                    }) {
                        Text("Trade")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 44)
                            .background(RoundedRectangle(cornerRadius: 22).fill(Color.green))
                    }
                    .modal(isPresented: $presented) {
                        cv(stockDetailVM: stockDetailVM, stockTicker: stockTicker, presented: $presented, currentStockData : currentStockData)
                    }
                }
            }
        }
    }
    func updateCurrentPortfolio() {
        let endpoint = "/api/getCurrentPortfolio?ticker="+stockTicker
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: GetCurrentPortFolioData = data?.parseTo() else { print("No Data"); return }
                self.currentStockData.currentPortfolioModel = res
                self.presented.toggle()
            }
        })
    }
}


struct cv: View {
    @State private var name = ""
    
    @ObservedObject var stockDetailVM: StockDetailViewModel
    var stockTicker: String
    @Binding var presented: Bool  // Changed to Binding
    @ObservedObject var currentStockData:CurrentPortfolioModel
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showSuccessModal: Bool = false
    @State private var successModalMessage: String = ""
    
    var body: some View {
        VStack{
            if showSuccessModal{
                VStack {
                    Spacer()
                    Text("Congratulations!")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        
                    Text("\(successModalMessage)").foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        updateNumbers()
                        presented.toggle()
                        print(self.presented)
                    }) {
                        Text("Done")
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                            .padding()
                            .frame(width: 200, height: 44) // Set the width to 200 and height to 44
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white)) // Curve the edges with a cornerRadius of 10
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green)
            }
            
            else{
                
                VStack(){
                    Text("Trade " + stockDetailVM.stockDetailData.insightsData.companyName + " shares").padding(20)
                    Spacer()
                    HStack {
                        Spacer()
                        TextField("0", text: $name)
                            .font(.system(size: 100, weight: .semibold)) // Adjust the font size and set to bold
                        VStack {
                            Text("Share")
                                .fontWeight(.semibold)
                                .font(.title)
                            // Ensure the MarketValue is treated as a numeric type for formatting
                            Text("x $\(self.currentStockData.currentPortfolioModel.currentPrice, specifier: "%.2f")/share = $\(calculateTotal())")
                        }
                        Spacer()
                    }
                    Spacer()
                    Text("$\(String(format: "%.2f", 25000 - self.currentStockData.currentPortfolioModel.totalSpend)) available to buy \(stockTicker)")

                    HStack{
                        Button(action: {
                            buyStocks(stockName: stockTicker, quantity: name, isBuy: "true")
                        }) {
                            Text("Buy")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(height: 44)
                                .background(RoundedRectangle(cornerRadius: 22).fill(Color.green))
                        }
                        .buttonStyle(PlainButtonStyle())
                        Button(action: {
                            buyStocks(stockName: stockTicker, quantity: name, isBuy: "false")
                        }) {
                            Text("Sell")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(height: 44)
                                .background(RoundedRectangle(cornerRadius: 22).fill(Color.green))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if showToast{
                        ToastView(toastMessage: self.toastMessage)
                                            .transition(.move(edge: .top).combined(with: .opacity))
                                            .zIndex(1)
                    }
                }.padding(.top, 10)
            }
        }
        
        
    }
    func calculateTotal() -> String {
        if let inputDouble = Double(name) {
            let total = inputDouble * self.currentStockData.currentPortfolioModel.currentPrice
            
            return String(format: "%.2f", total)
        }
        return "0.00"
    }
    func buyStocks(stockName: String, quantity: String, isBuy : String) {
        if let quantityDouble = Double(quantity){
        }else{
            self.toastMessage = "Please enter a valid amount"
            self.showToast.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showToast = false
            }
            return
        }
        if(isBuy == "false"){
            if let quantityDouble = Double(quantity), quantityDouble > self.currentStockData.currentPortfolioModel.currentQuantity {
                self.toastMessage = "Not enough shares to sell"
                self.showToast.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showToast = false
                }
                return
            }
            if let quantityDouble = Double(quantity), quantityDouble <= 0 {
                self.toastMessage = "Cannot sell non-positive shares"
                self.showToast.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showToast = false
                }
                return
            }
        }
        if(isBuy == "true"){
            if let quantityDouble = Double(quantity), (quantityDouble * self.currentStockData.currentPortfolioModel.currentPrice)  > (25000 - self.currentStockData.currentPortfolioModel.totalSpend) {
                self.toastMessage = "Not enough money to buy"
                self.showToast.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showToast = false
                }
                return
            }
            if let quantityDouble = Double(quantity), quantityDouble <= 0 {
                self.toastMessage = "Cannot buy non-positive shares"
                self.showToast.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showToast = false
                }
                return
            }
        }
        var urlComponents = URLComponents()
        let params: [URLQueryItem] = [URLQueryItem(name: "ticker", value: stockName), URLQueryItem(name: "quantity", value: quantity), URLQueryItem(name: "isBuy", value: isBuy)]
        
        urlComponents.path = "/api/addUpdatePortfolio"
        urlComponents.queryItems = params
        
        let endpoint = urlComponents.url!.absoluteString
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: {
            data in
            if data != nil {
                guard let res: ErrorMessage = data?.parseTo() else { print("No Data"); return }
                self.successModalMessage = res.message
                self.showSuccessModal = true
                print("Success")
            } else {
                print("Failure")
            }
        })
    }
    func updateNumbers() {
        let endpoint = "/api/getPortfolioAllData?ticker="+stockTicker
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: GetDataCurrentPortfolioModel = data?.parseTo() else { print("No Data"); return }
                self.stockDetailVM.stockDetailData.portFolioData.stockBroughtFlag = res.stockBroughtFlag
                self.stockDetailVM.stockDetailData.portFolioData.stocksOwnedQuantity = res.quantity
                self.stockDetailVM.stockDetailData.portFolioData.AvgCostPerShare = String(format: "%.2f", res.averageCost)
                self.stockDetailVM.stockDetailData.portFolioData.TotalCost = String(format: "%.2f", res.totalCost)
                self.stockDetailVM.stockDetailData.portFolioData.Change = String(format: "%.2f", res.change)
                self.stockDetailVM.stockDetailData.portFolioData.MarketValue = String(format: "%.2f", res.marketValue)
                self.stockDetailVM.stockDetailData.portFolioData.CurrentPrice = String(format: "%.2f", res.marketValue)
            }
        })
    }
    func updateCurrentPortfolio() {
        let endpoint = "/api/getCurrentPortfolio?ticker="+stockTicker
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: GetCurrentPortFolioData = data?.parseTo() else { print("No Data"); return }
                self.currentStockData.currentPortfolioModel = res
                self.presented.toggle()
            }
        })
    }
}
struct ToastView: View {
    let toastMessage: String
    var body: some View {
        Text(toastMessage)
            .padding()
            .frame(width: 300)  // Set the explicit width here
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.top, 50)  // Adjust positioning
    }
}
