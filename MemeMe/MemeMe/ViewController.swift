//
//  ViewController.swift
//  MemeMe
//
//  Created by Ramiz on 07/05/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func experiment() {
        let controller = UIImagePickerController()
        self.present(controller, animated: true, completion: nil)
    }
}

