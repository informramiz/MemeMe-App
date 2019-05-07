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
    private var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //add a label to show counter
        addCounterLabel()
        //add button to increment counter label
        addIncrementCounterButton()
    }

    /**
     MARK: Add counter label to root view
    */
    private func addCounterLabel() {
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 150, width: 60, height: 60)
        label.text = "0"
        view.addSubview(label)
        self.counterLabel = label
    }
    
    /**
     MARK: Add button to increment counter
     */
    private func addIncrementCounterButton() {
        let incrementCountButton = UIButton()
        incrementCountButton.frame = CGRect(x: 150, y: 250, width: 60, height: 60)
        incrementCountButton.setTitle("Click", for: .normal)
        incrementCountButton.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(incrementCountButton)
        
        incrementCountButton.addTarget(self, action: #selector(incrementCount), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func incrementCount() {
        count += 1
        self.counterLabel.text = "\(self.count)"
    }
}

