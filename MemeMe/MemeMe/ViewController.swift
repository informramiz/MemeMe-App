//
//  ViewController.swift
//  MemeMe
//
//  Created by Ramiz on 07/05/2019.
//  Copyright © 2019 RR Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var mediaOptionsToolbar: UIToolbar!
    
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
        updateNavBarButtonsStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //stop listening to keyboard show/hide notifications
    }
    
    //sets the status of nav buttons to enabled/disabled depending on if image is loaded or not
    private func updateNavBarButtonsStatus() {
        let isImageLoad = imageView.image != nil
        shareButton.isEnabled = isImageLoad
        cancelButton.isEnabled = isImageLoad
    }
    
    //MARK: Actions
    @IBAction func pickImageFromGallery(_ sender: Any) {
        pickImage(source: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImage(source: .camera)
    }
    
    fileprivate func pickImage(source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func showErrorAlert(_ msg: String) {
        let controller = UIAlertController()
        controller.title = "MemeMe"
        controller.message = msg
        
        let okAction = UIAlertAction(title: "ok", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func setNavBarAndToolbarVisibility(isVisible: Bool) {
        navBar.isHidden = !isVisible
        mediaOptionsToolbar.isHidden = !isVisible
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = getMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!,
                        originalImage: imageView.image!, memedImage: memedImage)
        shareCurrentMeme(meme)
    }
    
    @IBAction func cancel(_ sender: Any) {
        imageView.image = nil
        updateNavBarButtonsStatus()
    }
    
    private func getMemedImage() -> UIImage {
        //hide nav bar and toolbars so that they are not part of memed image
        setNavBarAndToolbarVisibility(isVisible: false)
        
        //TODO: save image here
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //show nav bar/toolbars again
        setNavBarAndToolbarVisibility(isVisible: true)
        return image
    }
    
    private func shareCurrentMeme(_ meme: Meme) {
        let shareController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        shareController.completionWithItemsHandler = {_, success, _, error in
            if success {
                self.saveMemedImage(meme.memedImage)
            } else {
                let errorMsg = error?.localizedDescription ??  "Sharing cancelled"
                self.showErrorAlert(errorMsg)
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    
    private func saveMemedImage(_ memeImage: UIImage) {
        UIImageWriteToSavedPhotosAlbum(memeImage, self, #selector(onImageSaveResult(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func onImageSaveResult(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showErrorAlert(error.localizedDescription)
        } else {
            showErrorAlert("Image saved successfully")
        }
    }
    
    //MARK: Delegate methods
    
    //called when image picker action is cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //called when image is successfully selected by the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let originalImage = originalImage {
            self.imageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
        updateNavBarButtonsStatus()
    }
    
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

