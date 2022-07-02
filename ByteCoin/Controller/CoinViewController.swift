//
//  ViewController.swift
//  ByteCoin
//
//  Created by Кирилл on 02.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {

    @IBOutlet weak var coinValueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinHandler = CoinHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinHandler.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        coinHandler.fetchBitcoin(currency: coinHandler.currencyArray[0])
        currencyLabel.text = coinHandler.currencyArray[0]
    }
}

// MARK: - PickerViewDelegate and Datasource Section
extension CoinViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Количество элементов
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinHandler.currencyArray.count
    }
    
    // Название элемента
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent  component: Int) -> String? {
        return coinHandler.currencyArray[row]
    }
    
    // Выбранный элемент
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyLabel.text = coinHandler.currencyArray[row]
        coinHandler.fetchBitcoin(currency: coinHandler.currencyArray[row])
    }
}

// MARK: - CoinHandlerDelegate Section
extension CoinViewController: CoinHandlerDelegate {
    
    func didUpdateCoinValue(_ coinHandler: CoinHandler, coinModel: CoinModel) {
        DispatchQueue.main.async {
            self.coinValueLabel.text = String(coinModel.rate)
        }
    }
    
    func didFailWithError(error: Error) {
        print("Возникла ошибка: \(error)")
    }
    
}
