//
//  GetHairstyleView.swift
//  HairLink
//
//  Created by James Truong on 7/9/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit

protocol GetHairstyleDelegate {
    func downloadButtonTapped(appendingUrl: String)
    //    Or make a delegate where upload starts after dismiss
}

class GetHairstyleView: UIView, Modal {
    
    var delegate: GetHairstyleDelegate?
    
    var backgroundView = UIView()
    var dialogView = UIView()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Get a hairstyle from your stylist"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    let firstLineView = UIView()

    
    lazy var publicOrPrivateLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your stylist's account email"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
//        label.numberOfLines = 2
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Stylist's Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .yes
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return tf
    }()
    
    lazy var accessCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the access code your stylist received after saving the hairstyle"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    lazy var accessCodeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Access Code"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .allCharacters
        tf.spellCheckingType = .no
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return tf
    }()
    
    
    lazy var getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download", for: .normal)
        button.backgroundColor = UIColor.mainBlue()
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        button.isEnabled = true
        return button
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        layoutCustomAlert()
        
    }
    
    
    
    func layoutCustomAlert() {
        dialogView.clipsToBounds = true
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width - 64
        
        titleLabel.frame.origin = CGPoint(x: 8, y: 4)
        titleLabel.frame.size = CGSize(width: dialogViewWidth - 16, height: 30)
        dialogView.addSubview(titleLabel)
        
        firstLineView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + 8)
        firstLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        firstLineView.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(firstLineView)
        
        publicOrPrivateLabel.frame.origin = CGPoint(x: 8, y: firstLineView.frame.height + firstLineView.frame.origin.y + 4)
        publicOrPrivateLabel.frame.size = CGSize(width: dialogViewWidth - 16, height: 20)
        dialogView.addSubview(publicOrPrivateLabel)
        
        emailTextField.frame.origin = CGPoint(x: 16, y: publicOrPrivateLabel.frame.height + publicOrPrivateLabel.frame.origin.y + 8)
        emailTextField.frame.size = CGSize(width: dialogViewWidth - 32, height: 40)
        dialogView.addSubview(emailTextField)
    
        
        accessCodeLabel.frame.origin = CGPoint(x: 8, y: emailTextField.frame.height + emailTextField.frame.origin.y + 4)
        accessCodeLabel.frame.size = CGSize(width: dialogViewWidth - 16, height: 40)
        dialogView.addSubview(accessCodeLabel)
        
        
        accessCodeTextField.frame.origin = CGPoint(x: 16, y: accessCodeLabel.frame.height + accessCodeLabel.frame.origin.y + 8)
        accessCodeTextField.frame.size = CGSize(width: dialogViewWidth - 32, height: 40)
        dialogView.addSubview(accessCodeTextField)
        
        getButton.frame.origin = CGPoint(x: 64, y: accessCodeTextField.frame.height + accessCodeTextField.frame.origin.y + 16)
        getButton.frame.size = CGSize(width: dialogViewWidth - 128, height: 40)
        dialogView.addSubview(getButton)
        
        let titleAndFirstFieldHeight = titleLabel.frame.height + 8 + firstLineView.frame.height + 4 + publicOrPrivateLabel.frame.height + 4 + accessCodeTextField.frame.height + 16
        
        let secondFieldAndButtonHeight = accessCodeLabel.frame.height + 4 + accessCodeTextField.frame.height + 4 + getButton.frame.height + 16
        
        let dialogViewHeight =  titleAndFirstFieldHeight + secondFieldAndButtonHeight
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 4
        addSubview(dialogView)
    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
    

    @objc func textFieldDidChange() {
        
       
    }
    
    @objc func uploadTapped() {

//            let actions = [UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)]
//            backgroundView.alertUIView(message: "", title: "Please make sure you have selected all the required choices", actions: actions)
//
        
        guard let email = emailTextField.text else { return }
        guard let accessCode = accessCodeTextField.text else { return }
        

//        let personalProfilesController = PersonalProfilesController()
        let appendingUrl = "api/v1/hairprofiles/?user__email=\(email)&access_code=\(accessCode)"
   
        delegate?.downloadButtonTapped(appendingUrl: appendingUrl)
        
        dismiss(animated: true)
//        delegate?.getUserHairProfiles()
        
//        This is only create an instance and changing that instance of the variable. Could check for dismissall. Or add delegate to main controller. If upload tapped then changing appending url
//        Variable is not changed....
//        dismiss(animated: true)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
