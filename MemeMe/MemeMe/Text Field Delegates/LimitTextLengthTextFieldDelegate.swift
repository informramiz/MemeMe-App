//
//  File.swift
//  MemeMe
//
//  Created by Apple on 09/05/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import Foundation
import UIKit

class LimitTextLengthTextFieldDelegate: NSObject, UITextFieldDelegate {
    var maximumLimit: Int = 5
    init(limit: Int = 5){
        self.maximumLimit = limit
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let previousText = textField.text! as NSString
        let newText = previousText.replacingCharacters(in: range, with: string)
        
        if newText.count > maximumLimit {
            textField.text = String(newText.prefix(maximumLimit))
            return false
        } else {
            return true
        }
    }
}
