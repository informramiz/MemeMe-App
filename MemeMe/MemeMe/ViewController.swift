//
//  ViewController.swift
//  MemeMe
//
//  Created by Ramiz on 07/05/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emojiTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var characterCountTextField: UITextField!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    private let emojiTextFieldDelegate = EmojiTextFieldDelegate()
    private let colorizerTextFieldDelegate = ColorizerTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.characterCountLabel.isHidden = true
        self.emojiTextField.delegate = emojiTextFieldDelegate
        self.colorTextField.delegate = colorizerTextFieldDelegate
        self.characterCountTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullText = textField.text! as NSString
        
        let newText = fullText.replacingCharacters(in: range, with: string)
        
        characterCountLabel.isHidden = newText.isEmpty
        characterCountLabel.text = String(newText.count)
        return true
    }
}

