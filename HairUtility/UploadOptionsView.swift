//
//  UploadOptionsController.swift
//  HairLink
//
//  Created by James Truong on 7/3/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit


protocol UploadOptionsDelegate {
    func uploadOptionsButtonTapped(hairLengthTag: String, genderTag: String, isPubliclyDisplayable: Bool, extraTags: [String])
//    Or make a delegate where upload starts after dismiss
}


class CustomAlert: UIView, Modal {
    
    var delegate: UploadOptionsDelegate?
    var hairLengthTag: String?
    var genderTag: String?
    var isPubliclyDisplayable: Bool?
    var extraTagsArray = [String]()
    
    var backgroundView = UIView()
    var dialogView = UIView()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Upload Options"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    let firstLineView = UIView()
    
    lazy var lengthSegmentedControl: UISegmentedControl = {
        let choices = ["Short", "Medium", "Long"]
        let segmentedControl = UISegmentedControl(items: choices)
        segmentedControl.layer.cornerRadius = 4.0
        segmentedControl.tintColor = UIColor.mainBlue()
        segmentedControl.addTarget(self, action: #selector(lengthTapped), for: .valueChanged)
        return segmentedControl
        
    }()
    
    
    lazy var genderSegmentedControl: UISegmentedControl = {
        let choices = ["Women", "Men"]
        let segmentedControl = UISegmentedControl(items: choices)
        segmentedControl.layer.cornerRadius = 4.0
        segmentedControl.tintColor = UIColor.mainBlue()
        segmentedControl.addTarget(self, action: #selector(genderTapped), for: .valueChanged)
        return segmentedControl
        
    }()
    
    
    lazy var publicOrPrivateSegmentedControl: UISegmentedControl = {
        let choices = ["Private", "Public"]
        let segmentedControl = UISegmentedControl(items: choices)
        segmentedControl.layer.cornerRadius = 4.0
        segmentedControl.tintColor = UIColor.mainBlue()
        segmentedControl.addTarget(self, action: #selector(publicTapped), for: .valueChanged)
        return segmentedControl
        
    }()
    
    let secondLineView = UIView()
    
    lazy var publicOrPrivateLabel: UILabel = {
        let label = UILabel()
        label.text = "Private hairstyles can still be sent to your client's account"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let thirdLineView = UIView()
    
    
    
    lazy var tagsLabel: UILabel = {
        let label = UILabel()
        label.text = "(Optional) Add up to three tags and separate them with commas and spaces"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    
    lazy var tagsTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "two-layered, undercut, jennifer-lawrence"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .yes
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return tf
    }()
    
    
    lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload", for: .normal)
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
        
        
        lengthSegmentedControl.frame.origin = CGPoint(x: 16, y: firstLineView.frame.height + firstLineView.frame.origin.y + 8)
        lengthSegmentedControl.frame.size = CGSize(width: dialogViewWidth - 32, height: 40)
        dialogView.addSubview(lengthSegmentedControl)
        
        genderSegmentedControl.frame.origin = CGPoint(x: 16, y: lengthSegmentedControl.frame.height + lengthSegmentedControl.frame.origin.y + 12)
        genderSegmentedControl.frame.size = CGSize(width: dialogViewWidth - 32, height: 40)
        dialogView.addSubview(genderSegmentedControl)
        
        publicOrPrivateSegmentedControl.frame.origin = CGPoint(x: 16, y: genderSegmentedControl.frame.height + genderSegmentedControl.frame.origin.y + 12)
        publicOrPrivateSegmentedControl.frame.size = CGSize(width: dialogViewWidth - 32, height: 40)
        dialogView.addSubview(publicOrPrivateSegmentedControl)
        
        
        secondLineView.frame.origin = CGPoint(x: 0, y: publicOrPrivateSegmentedControl.frame.height + publicOrPrivateSegmentedControl.frame.origin.y + 8)
        secondLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        secondLineView.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(secondLineView)
        
        
        publicOrPrivateLabel.frame.origin = CGPoint(x: 8, y: secondLineView.frame.height + secondLineView.frame.origin.y + 4)
        publicOrPrivateLabel.frame.size = CGSize(width: dialogViewWidth - 16, height: 40)
        dialogView.addSubview(publicOrPrivateLabel)
        
        
        thirdLineView.frame.origin = CGPoint(x: 0, y: publicOrPrivateLabel.frame.height + publicOrPrivateLabel.frame.origin.y + 4)
        thirdLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        thirdLineView.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(thirdLineView)
        
        
        tagsLabel.frame.origin = CGPoint(x: 8, y: thirdLineView.frame.height + thirdLineView.frame.origin.y + 4)
        tagsLabel.frame.size = CGSize(width: dialogViewWidth - 16, height: 40)
        dialogView.addSubview(tagsLabel)
        
        
        tagsTextField.frame.origin = CGPoint(x: 16, y: tagsLabel.frame.height + tagsLabel.frame.origin.y + 8)
        tagsTextField.frame.size = CGSize(width: dialogViewWidth - 32, height: 40)
        dialogView.addSubview(tagsTextField)
        
        uploadButton.frame.origin = CGPoint(x: 64, y: tagsTextField.frame.height + tagsTextField.frame.origin.y + 16)
        uploadButton.frame.size = CGSize(width: dialogViewWidth - 128, height: 40)
        dialogView.addSubview(uploadButton)
        
        let titleAndSegmentedControlsHeight = titleLabel.frame.height + 8 + firstLineView.frame.height + 8 + lengthSegmentedControl.frame.height + 12 + genderSegmentedControl.frame.height + 12 + publicOrPrivateSegmentedControl.frame.height + 8 + secondLineView.frame.height + 4  + publicOrPrivateLabel.frame.height + 4
        
        let tagsAndButtonHeight = secondLineView.frame.height + 4 + tagsLabel.frame.height + 4 + tagsTextField.frame.height + 16 + uploadButton.frame.height + 16
        
        let dialogViewHeight =  titleAndSegmentedControlsHeight + tagsAndButtonHeight
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 4
        addSubview(dialogView)
    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
    @objc func lengthTapped() {
        
        switch lengthSegmentedControl.selectedSegmentIndex {
            
        case 0:
            hairLengthTag = "short"
            
        case 1:
            hairLengthTag = "medium"
            
        case 2:
            hairLengthTag = "long"
    
        default:
            hairLengthTag = nil
        }
        
    }
    
    
    @objc func genderTapped() {
        print("gender control tapped")

        
        switch genderSegmentedControl.selectedSegmentIndex {
        case 0:
            genderTag = "women"
            
        case 1:
            genderTag = "men"
            
        default:
            genderTag = nil
        }
        
    }
    
    @objc func publicTapped() {
       
        switch publicOrPrivateSegmentedControl.selectedSegmentIndex {
            
        case 0:
            isPubliclyDisplayable = false
        
        case 1:
            isPubliclyDisplayable = true
            
        default:
            isPubliclyDisplayable = nil
            
        }
    }
    
    @objc func textFieldDidChange() {
        
        let tags = tagsTextField.text?.components(separatedBy: ", ")
        
        if tags?.isEmpty == false {
             extraTagsArray = tags!
        }

        
    }
    
    @objc func uploadTapped() {
        print("upload tapped")
        
        guard lengthSegmentedControl.selectedSegmentIndex != -1, genderSegmentedControl.selectedSegmentIndex != -1, publicOrPrivateSegmentedControl.selectedSegmentIndex != -1 else {
            let actions = [UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)]
            backgroundView.alertUIView(message: "", title: "Please make sure you have selected all the required choices", actions: actions)
            return
        }
        guard let hairLengthTag = self.hairLengthTag else { return }
        guard let genderTag = self.genderTag else { return }
        guard let isPubliclyDisplayable = self.isPubliclyDisplayable else { return }
        guard extraTagsArray.count <= 3 else { return }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (action) in
            self.delegate?.uploadOptionsButtonTapped(hairLengthTag: hairLengthTag, genderTag: genderTag, isPubliclyDisplayable: isPubliclyDisplayable, extraTags: self.extraTagsArray)
            self.dismiss(animated: true)
        }
        
        let actions = [noAction, yesAction]
        backgroundView.alertUIView(message: "", title: "Are you sure you want to upload?", actions: actions)
       
 
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
