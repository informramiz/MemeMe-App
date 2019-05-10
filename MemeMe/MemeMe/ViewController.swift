//
//  ViewController.swift
//  MemeMe
//
//  Created by Ramiz on 07/05/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    
    //apply default text attributes for our text fields
    private let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -3,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //apply our custom define default text attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //as setting textField.defaultTextAttributes reset text alignment
        //so set text alignment here to make sure text is center aligned
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
        
        // register our controller as delegate for both top/bottom text fields
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        //only show camera button if camera present
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //start listening for keyboard show/hide notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //stop listening to keyboard show/hide notifications
    }
    
    fileprivate func pickImage(source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromGallery(_ sender: Any) {
        pickImage(source: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImage(source: .camera)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let originalImage = originalImage {
            self.imageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == "TOP" || textField.text! == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if topTextField.text!.isEmpty {
            textField.text = "TOP"
        }
        
        if bottomTextField.text!.isEmpty {
            bottomTextField.text = "Bottom"
        }
    }
    
    
    //notifications handling code
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //selector for keyboard will show notification
    //add @objc because we need to expose this method to object-c as selector
    //get the height of the keyboard and move the root view's bottom up by
    //keyboard height
    @objc private func keyboardWillShow(_ notification: Notification) {
        //only bottom text field can be covered by keyboard so
        //only move view up if bottom text field is being edited
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //selector for keyboard hide notification
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    //return the keyboard size
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}

