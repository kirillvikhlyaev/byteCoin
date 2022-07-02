//
//  CoinHandler.swift
//  ByteCoin
//
//  Created by Кирилл on 02.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import Foundation

protocol CoinHandlerDelegate {
    func didUpdateCoinValue(_ coinHandler: CoinHandler, coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinHandler {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "E7AE7DB7-2D9C-4EE3-B548-EB1C6F5B6F79"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinHandlerDelegate?
    
    func fetchBitcoin(currency: String) {
        let responceURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: responceURL)
    }
    
    func performRequest(with responceURL: String) {
        if let url = URL(string: responceURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coinModel = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoinValue(self, coinModel: coinModel)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
        
            let rate = decodedData.rate
            
            let coin = CoinModel(rate: rate)
            return coin
        } catch {
            print(error)
            return nil
        }
    }
}
