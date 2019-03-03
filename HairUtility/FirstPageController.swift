//
//  FirstPageController.swift
//  HairLink
//
//  Created by James Truong on 8/3/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import KeychainAccess

protocol FirstPageDelegate {
    func nextButtonPressed()
}


class FirstPageController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
//    Still need to fix returning 0
    
    var delegate: FirstPageDelegate?

    
    
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
    
    let addressLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "Address"
        return label
    }()
    
    lazy var addressTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "606 Wolverton Drive"
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let cityLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "City"
        return label
    }()
    
    lazy var cityTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "Fort Wayne"
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let stateLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "State"
        return label
    }()
    
    lazy var stateTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "IN"
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let zipCodeLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "Zip Code"
        return label
    }()
    
    lazy var zipCodeTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "46825"
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let phoneNumberLabel: BaseTextLabel = {
        let label = BaseTextLabel()
        label.text = "Phone Number"
        return label
    }()
    
    lazy var phoneNumberTextField: BottomBorderTextField = {
        let textField = BottomBorderTextField()
        textField.placeholder = "1112223333"
        textField.delegate = self
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    
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
        
        postCompanyInfo()
        
     
        
        
    }

    @objc func handleTextInputChange() {
        
        
        guard companyNameTextField.text != nil && addressTextField.text != nil && cityTextField.text != nil && stateTextField.text != nil && zipCodeTextField.text != nil else {
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
        
        self.navigationItem.title = "Company"
        
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

        let stackView = UIStackView(arrangedSubviews: [companyLabel, companyNameTextField, addressLabel, addressTextField, cityLabel, cityTextField, stateLabel, stateTextField, zipCodeLabel, zipCodeTextField, phoneNumberLabel, phoneNumberTextField])
        
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 2, paddingLeft: 16, paddingBottom: 0, paddingRight: 64, width: 300, height: 400)
        
        view.addSubview(nextPageButton)
        nextPageButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 50, height: 50)
    }
    
    
    
    var authToken: String?
    
    func postCompanyInfo() {
    
        
        guard let name = companyNameTextField.text else { return }
        guard let address = addressTextField.text else { return }
        guard let state = stateTextField.text else { return }
        guard let city = cityTextField.text else { return }
        guard let zipCode = zipCodeTextField.text else { return }
        guard let phone = phoneNumberTextField.text else { return }
        
        let authToken = KeychainKeys.authToken
       
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        let parameters = [
            "company_name": name,
            "address": address,
            "state": state,
            "city": city,
            "zip_code": zipCode,
            "phone_number": phone
        ]

        
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api/v1/companies/", headers: headers, parameters: parameters, success: { (company) in
            guard let company = company as? Company else { return }
            print(company)
            
            self.alert(message: "", title: "Successfully created a company")
            self.delegate?.nextButtonPressed()
            
            
            do {
                
                let keychain = Keychain(service: "com.HairUtility")
                
                try keychain.set(company.pk, key: "companyPk")
                
            } catch let error {
                
                print(error)
            }
            
        }) { (err) in
            print(err)
            self.alert(message: "", title: "Error: \(err)")
        }
        
    }

}
