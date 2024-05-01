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
                        TradeView(stockDetailVM: stockDetailVM, stockTicker: stockTicker)
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
                Button(action: {
                    updateWatchlist()
                }) {
                    if stockDetailVM.stockDetailData.watchlistFlag {
                        Image(systemName: "plus")
                                                .foregroundColor(.white)
                                                .padding(4)
                                                .background(Circle().fill(Color.blue))
                    }else{
                        Image(systemName: "plus")
                            .foregroundColor(.blue)  // Set the color of the plus symbol
                            .font(.system(size: 10)) // Set the size of the plus symbol
                            .padding(6)  // Adjust padding to control the space around the icon inside the circle
                            .background(
                                Circle()  // Create a circle around the icon
                                    .stroke(Color.blue, lineWidth: 2)  // Only outline the circle with blue color
                                    .background(Circle().fill(Color.white))  // Fill the circle with white
                            )
                    }
                    
                }
            }
        }
        .toast(isPresenting: $showToast, alert: {
            AlertToast(displayMode: .hud, type: .regular, title: toastMessage)
        })
    
//       .navigationBarTitleDisplayMode(.large)
//        .navigationBarItems(trailing: Image(systemName: "plus")
//            .foregroundColor(.white)
//            .padding(4)
//            .background(Circle().fill(Color.blue)))
    }
    
    func updateWatchlist() {
        print("hello")
        var urlComponents = URLComponents()
        let params: [URLQueryItem]
        if stockDetailVM.stockDetailData.watchlistFlag{
            params = [URLQueryItem(name: "ticker", value: stockTicker), URLQueryItem(name: "isStar", value: "false")]
        }else{
            params = [URLQueryItem(name: "ticker", value: stockTicker), URLQueryItem(name: "isStar", value: "true")]
        }
        
        urlComponents.path = "/api/setWatchlist"
        urlComponents.queryItems = params
        
        let endpoint = urlComponents.url!.absoluteString
        
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: {
            data in
            if data != nil {
                guard let res: ErrorMessage = data?.parseTo() else { print("No Data"); return }
                self.toastMessage = res.message
                self.showToast.toggle()
                if stockDetailVM.stockDetailData.watchlistFlag{
                    stockDetailVM.stockDetailData.watchlistFlag = false
                }else{
                    stockDetailVM.stockDetailData.watchlistFlag = true
                }
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
