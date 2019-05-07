//
//  ViewController.swift
//  MemeMe
//
//  Created by Ramiz on 07/05/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var count = 0
    @IBOutlet var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: increments the counter and updates the label
    @IBAction private func incrementCount() {
        count += 1
        self.counterLabel.text = "\(self.count)"
    }
}

