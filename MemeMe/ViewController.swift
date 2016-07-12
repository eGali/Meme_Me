//
//  ViewController.swift
//  MemeMe
//
//  Created by Edgar on 7/12/16.
//  Copyright © 2016 Edgar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var imageViewWindow: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    var currentTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topText.delegate = self
        self.bottomText.delegate = self
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        topText.hidden = true
        bottomText.hidden = true
        shareButton.enabled = false
        
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topText{
            textField.text = ""
        }
        if textField == bottomText{
            textField.text = ""
            currentTextField = textField
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func imageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func cancelButton(sender: AnyObject) {
        imageViewWindow.image = nil
        shareButton.enabled = false
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        topText.hidden = true
        bottomText.hidden = true
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageViewWindow.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            topText.hidden = false
            bottomText.hidden = false
            shareButton.enabled = true
        }
    }
    
   
    @IBAction func share(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        topBar.hidden = true
        bottomBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        topBar.hidden = false
        bottomBar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(){
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!,
                        image: imageViewWindow.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as!AppDelegate).memes.append(meme)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let textField = currentTextField {
            if textField == bottomText {
                self.view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    


}

