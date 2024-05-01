//
//  CurrentPortfolioModel.swift
//  assignment_4
//
//  Created by Ruturaj Chintawar on 5/1/24.
//

import SwiftUI
import Foundation

class CurrentPortfolioModel: ObservableObject {
    @Published var currentPortfolioModel: GetCurrentPortFolioData = GetCurrentPortFolioData(
        currentPrice: 0,
        currentQuantity: 0,
        totalSpend: 0
    )

    init(tickerSymbol: String) {
        print(tickerSymbol)
        var endpoint = "/api/getCurrentPortfolio?ticker="+tickerSymbol
        print(endpoint)
        APIService.instance.callInternalGetAPI(endpoint: endpoint, completion: { data in
            if data != nil{
                guard let res: GetCurrentPortFolioData = data?.parseTo() else { print("No Data"); return }
                self.currentPortfolioModel = res
            }
        })
    }
}
