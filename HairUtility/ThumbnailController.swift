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
import ImagePicker



class ThumbnailController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagePickerDelegate {
    
    
    
    
    // MARK: ImagePicker Library
    


    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper is working")

    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    
        thumbnailImageView.image = images[0]
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("cancel is working")
        dismiss(animated: true, completion: nil)
    }
    


    //    Still need to fix returning 0
    
    

  
    
    // MARK: Views
    
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
    
    let hairstyleNameLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "Hairstyle Name"
        return label
    }()
    
    lazy var hairstyleNameTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.autocapitalizationType = .sentences
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    
    let thumbnailLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.textAlignment = .center
        label.text = "Thumbnail Image"
        return label
    }()
    

    lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 4
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        iv.layer.borderWidth = 1.0
        return iv
    }()
    
    @objc func imageTapped(button: UIButton) {
        
        var config = Configuration()
        
        config.doneButtonTitle = "Done"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.imageLimit = 1
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
 
    
    lazy var nextPageButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.isEnabled = true
        button.tintColor = .clear
        button.addTarget(self, action: #selector(nextPageButtonPressed), for: .touchUpInside)
   
        return button
        
    }()
    
    @objc func nextPageButtonPressed() {
   
        if let image = thumbnailImageView.image, let hairstyleName = hairstyleNameTextField.text, !hairstyleName.isEmpty  {
    
                delegate?.nextButtonPressed(hairstyleName: hairstyleName, image: image)
            
        } else {
            self.alert(message: "", title: "Please complete the two steps to continue")
        }
        

    
        
        
    }
    
    @objc func handleTextInputChange() {
        
        
        guard hairstyleNameTextField.text != nil else {
            return
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        
        
        view.backgroundColor = .white
        
        setupInputFields()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(button:)))
        thumbnailImageView.addGestureRecognizer(gestureRecognizer)
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    fileprivate func setupInputFields() {
        
        
        //        let mainSreenWidth = UIScreen.main.bounds.size.width
        //        let mainScreenHeight = UIScreen.main.bounds.size.height
        //
        
        let stackView = UIStackView(arrangedSubviews: [hairstyleNameLabel, hairstyleNameTextField])
        
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 32, left: 0, bottom: 0, right: 0), size: .init(width: 250, height: 50))
        

        
        
        view.addSubview(thumbnailLabel)
        view.addSubview(thumbnailImageView)
    
        thumbnailLabel.anchor(top: stackView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 64, left: 0, bottom: 0, right: 0),  size: .init(width: 168, height: 25))
 
        thumbnailImageView.anchor(top: thumbnailLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 32, left: 0, bottom: 0, right: 0),  size: .init(width: 168, height: 168))
     
        thumbnailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        
        thumbnailLabel.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor).isActive = true
        
        
        view.addSubview(nextPageButton)
        
        nextPageButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 4), size: .init(width: 50, height: 50))
    }
    
    
    
}
