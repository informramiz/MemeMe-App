//
//  CurrencyTextFieldDelegate.swift
//  MemeMe
//
//  Created by Apple on 09/05/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation
import UIKit

class CurrencyTextFieldDelegate: NSObject, UITextFieldDelegate {
    private let numberFormatter = NumberFormatter()
    private var previousString = "00"
    override init() {
        numberFormatter.numberStyle = .currency
//        numberFormatter.maximumIntegerDigits = 2
        numberFormatter.maximumFractionDigits = 2
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if previousString.isEmpty {
            previousString = textField.text!
        }
        
        let newText = previousString.appending(string)
        let decimalPart = newText.suffix(2)
        let integerPart = newText.prefix(newText.count - 2)
        
        //parse to int
        let number = Double("\(integerPart).\(decimalPart)")
        //if parsing failed then not a number so return false
        if let number = number {
            textField.text = numberFormatter.string(from: number as NSNumber)
        }
        
        previousString = newText
        return false
    }
}
