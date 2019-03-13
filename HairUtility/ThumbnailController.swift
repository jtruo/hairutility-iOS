//
//  ThumbnailController.swift
//  HairUtility
//
//  Created by James Truong on 3/3/19.
//  Copyright © 2019 James Truong. All rights reserved.
//


import UIKit
import IQKeyboardManagerSwift
import Alamofire
import KeychainAccess


class ThumbnailController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //    Still need to fix returning 0
    
    var delegate: ProfilePageDelegate?
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize.height = 1200
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()
    
    let companyLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "Company Name"
        return label
    }()
    
    lazy var companyNameTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "Hair Salon- Fort Wayne"
        textField.autocapitalizationType = .sentences
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "photoButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
        
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 1
        
        dismiss(animated: true, completion: nil)
    }
    
    
    lazy var nextPageButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "download"), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextPageButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        return button
        
    }()
    
    @objc func nextPageButtonPressed() {
        print("nextpage button pressed")
        // guard to check if image and hairstyule name are passed
        
        guard let image = plusPhotoButton.imageView?.image else { return }
        guard let hairstyleName = companyNameTextField.text else { return }
        delegate?.nextButtonPressed(hairstyleName: hairstyleName, image: image)
        
        
    }
    
    @objc func handleTextInputChange() {
        
        
        guard companyNameTextField.text != nil else {
            return
            
        }
        
        nextPageButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        nextPageButton.isEnabled = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        view.backgroundColor = .white
        
        setupInputFields()
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    fileprivate func setupInputFields() {
        
        
        //        let mainSreenWidth = UIScreen.main.bounds.size.width
        //        let mainScreenHeight = UIScreen.main.bounds.size.height
        //
        
        let stackView = UIStackView(arrangedSubviews: [companyLabel])
        
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 2, paddingLeft: 16, paddingBottom: 0, paddingRight: 64, width: 300, height: 400)
        
        view.addSubview(nextPageButton)
        nextPageButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 50, height: 50)
    }
    
    
    
}
