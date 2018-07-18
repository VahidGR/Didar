//
//  Camera.swift
//  JahanCo Catalog
//
//  Created by Vahid Ghanbarpour on 7/30/17.
//  Copyright © 2017 Vahid Ghanbarpour. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Camera: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var textView: UITextView!
    var placeholderLabel: UILabel!
    var mainImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "اضافه کردن دسته بندی"
        let imageWidth = view.frame.size.width - 20
        let mainImageHeight = (imageWidth * 3) / 4
        
        let contentScrollView = UIScrollView(frame: CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: self.view.frame.size.height))
        contentScrollView.contentSize.height = 667
        self.view.addSubview(contentScrollView)
        
        mainImage = UIImageView(frame: CGRect(x: (view.frame.size.width / 2) - (imageWidth / 2), y: 10, width: imageWidth, height: mainImageHeight))
        mainImage.contentMode = .scaleAspectFit
        mainImage.image = UIImage(named: "placeholder")
        contentScrollView.addSubview(mainImage)
        let mainImageButton = UIButton(frame: CGRect(x: (view.frame.size.width / 2) - (imageWidth / 2), y: 10, width: imageWidth, height: mainImageHeight))
        mainImageButton.addTarget(self, action: #selector(imagePressed), for: .touchUpInside)
        contentScrollView.addSubview(mainImageButton)
        
        let titleField = UITextField(frame: CGRect(x: 20, y: mainImageHeight + 30, width: view.frame.size.width - 40, height: 40))
        titleField.placeholder = "عنوان"
        titleField.textAlignment = .right
        titleField.textColor = UIColor.darkGray
        contentScrollView.addSubview(titleField)
        
        let devidingLabel = UILabel(frame: CGRect(x: 10, y: mainImageHeight + 70, width: view.frame.size.width - 20, height: 1))
        devidingLabel.backgroundColor = UIColor.darkGray
        contentScrollView.addSubview(devidingLabel)
        
        placeholderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width - 40, height: 40))
        placeholderLabel.text = "توضیحات"
        placeholderLabel.textAlignment = .right
        placeholderLabel.textColor = UIColor.init(white: 0, alpha: 0.23)
        placeholderLabel.backgroundColor = UIColor.white
        
        textView = UITextView(frame: CGRect(x: 20, y: mainImageHeight + 90, width: view.frame.size.width - 40, height: 120))
        textView.textAlignment = .right
        textView.font = placeholderLabel.font
        textView.textColor = UIColor.darkGray
        textView.backgroundColor = UIColor.white
        textView.delegate = self
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        textView.addSubview(placeholderLabel)
        contentScrollView.addSubview(textView)
        
        let devidingLabelII = UILabel(frame: CGRect(x: 10, y: mainImageHeight + 210, width: view.frame.size.width - 20, height: 1))
        devidingLabelII.backgroundColor = UIColor.darkGray
        contentScrollView.addSubview(devidingLabelII)
    }
    
    @objc func imagePressed() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Image Source", message: "Choose an Image Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message:"Camera not available.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                self.present(alert, animated: true){}
            }
        } ))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        } ))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        mainImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
