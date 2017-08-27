//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by peerapat atawatana on 5/26/2560 BE.
//  Copyright © 2560 DaydreamClover. All rights reserved.
//

import UIKit
import IQDropDownTextField
import Alamofire
import Kanna

class ViewController: UIViewController {

    // MARK: IBOutlet
    
    @IBOutlet weak var currencyFromPicker: IQDropDownTextField!
    @IBOutlet weak var currencyToPicker: IQDropDownTextField!
    @IBOutlet weak var sourceAmountTextfield: UITextField!
    @IBOutlet weak var destinationAmountTextfield: UITextField!
    
    // MARK: IBAction
    
    @IBAction func didClickOnConvert() {
        convert(from:   currencyFromPicker.selectedItem ?? "USD",
                to:     currencyToPicker.selectedItem ?? "USD",
                amount: sourceAmountTextfield.text ?? "1")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyFromPicker.isOptionalDropDown = false
        currencyFromPicker.itemList = ["USD", "THB", "JPY"]
        
        currencyToPicker.isOptionalDropDown = false
        currencyToPicker.itemList = ["USD", "THB", "JPY"]
    }

    // MARK: Function
    
    func convert(from:String, to:String, amount:String) {
        Alamofire.request("https://www.google.com/finance/converter?a=\(amount)&from=\(from)&to=\(to)").responseString { (responseData) in
            if let data = responseData.value {
                //print(data)
                
                if let doc = HTML(html: data, encoding: .utf8) {
                    
                    if let currencyResult = doc.xpath("//div[@id=\"currency_converter_result\"]/span").first?.text {
                        print(currencyResult)
                        let splitedCurrencyResult = currencyResult.components(separatedBy: " ")
                        if splitedCurrencyResult.count > 1 {
                            let rawCurrency = splitedCurrencyResult[0]
                            let unitCurrency = splitedCurrencyResult[1]
                            self.destinationAmountTextfield.text = rawCurrency
                        }
                    }
                }
            }
        }
    }


}

