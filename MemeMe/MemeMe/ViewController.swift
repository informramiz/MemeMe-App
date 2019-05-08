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
        showAlert()
    }
    
    private func showImagePicker() {
        let controller = UIImagePickerController()
        self.present(controller, animated: true, completion: nil)
    }
    
    private func showActivityController() {
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }

    private func showAlert() {
        let alertController = UIAlertController()
        alertController.title = "My alert"
        alertController.message = "My test message"
        
        //alert controller does not have any ok/cancel button of it's own so we have to add it
        //show that a user can dismiss it.
        let okActionButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okActionButton)
        present(alertController, animated: true, completion: nil)
    }
}

