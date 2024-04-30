//
//  stockDetailView.swift
//  assignment_4
//
//  Created by Karthik Patel on 4/15/24.
//

import struct Kingfisher.KFImage
import SwiftUI
import Modals
import AlertToast
struct stockDetailView: View {
    var stockTicker: String
    @StateObject private var stockDetailVM: StockDetailViewModel
    @State private var toastMessage = ""
    @State private var showToast = false
    
    init(stockTicker: String) {
        self.stockTicker = stockTicker
        _stockDetailVM = StateObject(wrappedValue: StockDetailViewModel(tickerSymbol: stockTicker))
    }
    
    var body: some View {
        NavigationView {
            ModalStackView{
                List{
                    Section(){
                        stockDetailInitialView(stockDetailVM: stockDetailVM)
                    }.listRowSeparator(.hidden)
                    Section() {
                        ChartTabView()
                    }
                    Section(){
                        stockDetailPortfolioView(stockDetailVM: stockDetailVM, stockTicker: stockTicker)
                    }.listRowSeparator(.hidden)
                    Section(){
                        stockDetailStatsView(stockDetailVM: stockDetailVM)
                    }.listRowSeparator(.hidden)
                    Section(){
                        stockDetailAbouView(stockDetailVM: stockDetailVM)
                    }.listRowSeparator(.hidden)
                    Section(){
                        stockDetailInsightsView(stockDetailVM: stockDetailVM)
                    }.listRowSeparator(.hidden)
                    Section(){
                        stockNewsDeatailsView(stockDetailVM: stockDetailVM)
                    }.listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle(stockTicker)
        .toolbar{
            ToolbarItem(placement: ToolbarItemPlacement.topBarTrailing){
                Image(systemName: "plus")
            }
        }
//       .navigationBarTitleDisplayMode(.large)
//        .navigationBarItems(trailing: Image(systemName: "plus")
//            .foregroundColor(.white)
//            .padding(4)
//            .background(Circle().fill(Color.blue)))
    }
    func deleteFavorites(stockTicker: String) {
        var urlComponents = URLComponents()
        let params: [URLQueryItem] = [URLQueryItem(name: "tickerSymbol", value: stockTicker), URLQueryItem(name: "isStar", value: "true")]
        
        urlComponents.path = "/api/setWatchlist"
        urlComponents.queryItems = params
        
        let endpoint = urlComponents.url!.absoluteString
        
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: {
            data in
            if data != nil {
                
                print("Success")
            } else {
                print("Failure")
            }
        })
    }
}

struct stockDetailInsightsView: View {
    @ObservedObject var stockDetailVM: StockDetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Insights")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            HStack {
                Spacer()
                Text("Insider Sentiments")
                    .font(.title2)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(stockDetailVM.stockDetailData.insightsData.companyName)
                        .fontWeight(.bold)
                    Divider()
                    Text("Total").fontWeight(.bold)
                    Divider()
                    Text("Positive").fontWeight(.bold)
                    Divider()
                    Text("Negative").fontWeight(.bold)
                    Divider()
                }
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("MSPR")
                        .fontWeight(.bold)
                    Divider()
                    Text(stockDetailVM.stockDetailData.insightsData.MSPRTotal)
                    Divider()
                    Text(stockDetailVM.stockDetailData.insightsData.MSPRPositive)
                    Divider()
                    Text(stockDetailVM.stockDetailData.insightsData.MSPRNegative)
                    Divider()
                }
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Change")
                        .fontWeight(.bold)
                    Divider()
                    Text(stockDetailVM.stockDetailData.insightsData.ChangeTotal)
                    Divider()
                    Text(stockDetailVM.stockDetailData.insightsData.ChangePositive)
                    Divider()
                    Text(stockDetailVM.stockDetailData.insightsData.ChangeNegative)
                    Divider()
                }
            }
        }
    }
}

struct stockDetailAbouView: View {
    @ObservedObject var stockDetailVM: StockDetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("About")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            HStack{
                VStack(alignment: .leading) {
                    Text("IPO Start Date:            ").bold()
                    Spacer()
                    Text("Industry:").bold()
                    Spacer()
                    Text("Webpage:").bold()
                    Spacer()
                    HStack {
                        Text("Company Peers:").bold()
                    }
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(stockDetailVM.stockDetailData.statsAboutSectionData.ipostartdate)
                    Spacer()
                    Text(stockDetailVM.stockDetailData.statsAboutSectionData.industry)
                    Spacer()
                    if let url = URL(string: stockDetailVM.stockDetailData.statsAboutSectionData.webpage),
                       !stockDetailVM.stockDetailData.statsAboutSectionData.webpage.isEmpty {
                        Link(stockDetailVM.stockDetailData.statsAboutSectionData.webpage, destination: url)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("")
                    }
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(stockDetailVM.stockDetailData.statsAboutSectionData.companypeers, id: \.self) { peer in
                                NavigationLink(destination: stockDetailView(stockTicker: peer)) {
                                    Text(peer + ",")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct stockDetailStatsView: View {
    @ObservedObject var stockDetailVM: StockDetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Stats")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("High Price: ").bold() + Text("$\(stockDetailVM.stockDetailData.statsAboutSectionData.highPrice)")
                    Text("Low Price: ").bold() + Text("$\(stockDetailVM.stockDetailData.statsAboutSectionData.lowprice)")
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Open Price: ").bold() + Text("$\(stockDetailVM.stockDetailData.statsAboutSectionData.openprice)")
                    Text("Prev. Close: ").bold() + Text("$\(stockDetailVM.stockDetailData.statsAboutSectionData.prevclose)")
                }
            }
        }
    }
}
struct EmptyView: View {
    // Define a variable using @State
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Increment") {
                // Update the variable
                count += 1
            }
        }
    }
}

struct stockDetailPortfolioView: View {
    @ObservedObject var stockDetailVM: StockDetailViewModel
    var stockTicker: String
    @State var presented: Bool = false
    @State private var userInput: String = ""
    @State private var totalValue: String = "0"
    @State private var Value: Double = 0
    @State private var totalValueText: String = "0"
    @State private var showSuccessModal: Bool = false
    @State private var successModalMessage: String = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Portfolio")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            Spacer()
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    if stockDetailVM.stockDetailData.portFolioData.stockBroughtFlag{
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
                        Text("You have 0 shares of "+stockTicker+".\nStart trading!")
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Button(action: {
                        self.presented.toggle()
                    }) {
                        Text("Trade")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 44)
                            .background(RoundedRectangle(cornerRadius: 22).fill(Color.green))
                    }
    
                    .modal(isPresented: self.$presented){
                        VStack{
                            if showSuccessModal{
                                VStack {
                                    Text("Congratulations!")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                    Text("\(successModalMessage)")
                                    Spacer()
                                    Button(action: {
                                        self.presented.toggle()
                                    }) {
                                        Text("Done")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(height: 44)
                                            .background(RoundedRectangle(cornerRadius: 22).fill(Color.green))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.green.opacity(0.3))
                            }
                            
                            else{
                                VStack(alignment: .trailing){
                                    Spacer()
                                    Text("Trade " + stockDetailVM.stockDetailData.insightsData.companyName + " shares")
                                    Spacer()
                                    HStack{
                                        TextField("0", text: $userInput)
                                            .keyboardType(.decimalPad)
                                        VStack
                                        {
                                            Text("Share")
                                            Text("x $\(stockDetailVM.stockDetailData.portFolioData.MarketValue)/share = $\(userInput)")
                                        }
                                    }
                                    Spacer()
                                    Text("$ available to buy " + stockTicker)
                                    HStack{
                                        Button(action: {
                                            buyStocks(stockName: stockTicker, quantity: userInput, isBuy: "true")
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
                                            buyStocks(stockName: stockTicker, quantity: userInput, isBuy: "false")
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
                                    .toast(isPresenting: $showToast){
                                        AlertToast(type: .regular, title: "\(toastMessage)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func buyStocks(stockName: String, quantity: String, isBuy : String) {
        if let quantityDouble = Double(quantity){
        }else{
            self.toastMessage = "Please enter a valid amount"
            DispatchQueue.main.async {
                self.showToast.toggle()
                return
            }
        }
        if(isBuy == "false"){
            if let quantityDouble = Double(quantity), quantityDouble > stockDetailVM.stockDetailData.currentPortFolioData.currentQuantity {
                self.toastMessage = "Not enough shares to sell"
                self.showToast.toggle()
                return
            }
            if let quantityDouble = Double(quantity), quantityDouble <= 0 {
                self.toastMessage = "Cannot sell non-positive shares"
                self.showToast.toggle()
                return
            }
        }
        if(isBuy == "true"){
            if let quantityDouble = Double(quantity), (quantityDouble * stockDetailVM.stockDetailData.currentPortFolioData.currentPrice)  > (25000 - stockDetailVM.stockDetailData.currentPortFolioData.totalSpend) {
                self.toastMessage = "Not enough money to buy"
                self.showToast.toggle()
                return
            }
            if let quantityDouble = Double(quantity), quantityDouble <= 0 {
                self.toastMessage = "Cannot buy non-positive shares"
                self.showToast.toggle()
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
                self.presented.toggle()
                self.showSuccessModal = true
                print("Success")
            } else {
                print("Failure")
            }
        })
        
    }
}

struct stockDetailInitialView: View {
    @ObservedObject var stockDetailVM: StockDetailViewModel
    
    var body: some View {
        HStack {
            Text(stockDetailVM.stockDetailData.insightsData.companyName).foregroundColor(.secondary)
                .font(.system(size: 20) )
            Spacer()
        }
        HStack(alignment: .bottom) {
            Text("$" + stockDetailVM.stockDetailData.portFolioData.CurrentPrice)
                .font(.system(size: 30, weight: .bold))
            if let changeInPriceFromTotalCostPercent = Float(stockDetailVM.stockDetailData.portFolioData.changeInPrice) {
                if changeInPriceFromTotalCostPercent > 0.0 {
                    Image(systemName: "arrow.up.forward")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                    Text(" $\(stockDetailVM.stockDetailData.portFolioData.changeInPrice) (\(stockDetailVM.stockDetailData.portFolioData.changeInPricePercent)%)")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                } else if changeInPriceFromTotalCostPercent == 0.0 {
                    Image(systemName: "minus")
                        .font(.system(size: 20))
                    Text(" $\(stockDetailVM.stockDetailData.portFolioData.changeInPrice) (\(stockDetailVM.stockDetailData.portFolioData.changeInPricePercent)%)")
                        .font(.system(size: 20))
                } else {
                    Image(systemName: "arrow.down.forward")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                    Text(" $\(stockDetailVM.stockDetailData.portFolioData.changeInPrice) (\(stockDetailVM.stockDetailData.portFolioData.changeInPricePercent)%)")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                }
                Spacer()
            } else {
                Text("Nan")
            }
        }
    }
}

#Preview {
    stockDetailView(stockTicker: "AAPL")
}
