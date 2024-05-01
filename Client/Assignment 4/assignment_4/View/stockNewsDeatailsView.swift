//
//  stockNewsDeatailsView.swift
//  assignment_4
//
//  Created by Ruturaj Chintawar on 4/29/24.
//

import Foundation

import SwiftUI
import struct Kingfisher.KFImage
import Modals
struct stockNewsDeatailsView: View {
    @ObservedObject var stockDetailVM: StockDetailViewModel
    @State var presented: Bool = false
    @State var selectedNews: newsData  = newsData(
        source: "",
        datetime: 0,
        image: "",
        headline: "",
        summary: "",
        url: ""
    )
    var body: some View {
        VStack {
            HStack {
                Text("News")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    KFImage(URL(string: stockDetailVM.firstNewsArticle.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
                Text(stockDetailVM.firstNewsArticle.source + "   " + timeDifference(unixTimestamp: stockDetailVM.firstNewsArticle.datetime))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(stockDetailVM.firstNewsArticle.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .fontWeight(.bold)
                Divider()
                ForEach($stockDetailVM.stockDetailData.newsData, id: \.self) { news in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(news.source.wrappedValue)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            Text(timeDifference(unixTimestamp: news.datetime.wrappedValue))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(news.headline.wrappedValue)
                                .fixedSize(horizontal: false, vertical: true)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        KFImage(URL(string: news.image.wrappedValue))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .onTapGesture {
                        self.presented.toggle()
                        self.selectedNews = news.wrappedValue
                    }
                    
                    Spacer()
                }
            }
        }
        .modal(isPresented: self.$presented){
            NavigationView {
                VStack {
                    Text(convertUnixTimeToDate(unixTime: selectedNews.datetime))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(selectedNews.headline)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Text(selectedNews.summary)
                        .font(.body)
                        .padding(.top)
                    HStack{
                        Text("For more details click")
                            .foregroundColor(.gray)
                        Link("here", destination: URL(string: selectedNews.url)!)
                        
                    }
                    HStack {
                        Link(destination: URL(string: "https://twitter.com/intent/post?text=\(selectedNews.headline)&url=\(selectedNews.url)")!) {
                            Image("twit")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        Link(destination: URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(selectedNews.url)")!) {
                            Image("fb")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                }
                .padding()
                
                .navigationTitle(selectedNews.source)
            }
        }
    }
    func convertUnixTimeToDate(unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy" // Format: March 21, 2024
        return dateFormatter.string(from: date)
    }
    func timeDifference(unixTimestamp: Int) -> String {
        let targetDate = Date(timeIntervalSince1970: Double(unixTimestamp))
        let now = Date()
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.hour, .minute]

        // Calculate the difference
        let interval = targetDate.timeIntervalSince(now)
        
        // Use absolute value to avoid negative output and decide the prefix
        let timeString = formatter.string(from: abs(interval)) ?? "Time difference not available"
        
        if interval > 0 {
            return "In \(timeString)"  // Future date
        } else {
            return "\(timeString) ago"  // Past date
        }
    }
}
