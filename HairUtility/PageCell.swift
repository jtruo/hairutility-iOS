//
//  PageCell.swift
//  HairLink
//
//  Created by James Truong on 11/23/17.
//  Copyright © 2017 James Truong. All rights reserved.
//


import UIKit

class PageCell: UICollectionViewCell {
    
    var page: Page? {
        didSet {
            
            guard let unwrappedPage = page else { return }
    
            guard let fullPath = Bundle.main.path(forResource: unwrappedPage.imagePath, ofType: "jpg") else { return }
            bearImageView.image = UIImage(contentsOfFile: fullPath)
            
            let attributedText = NSMutableAttributedString(string: unwrappedPage.headerText, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
            
            attributedText.append(NSAttributedString(string: "\n\n\n\(unwrappedPage.bodyText)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.gray]))
            
            descriptionTextView.attributedText = attributedText
            descriptionTextView.textAlignment = .center
          
        }
    }
    
    
    
    lazy var bearImageView: UIImageView = {
        let image = UIImage(contentsOfFile: "page1")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Join us today in our fun and games!", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        
        attributedText.append(NSAttributedString(string: "\n\n\nAre you ready for loads and loads of fun? Don't wait any longer! We hope to see you in our stores soon.", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        
        let topImageContainerView = UIView()
       
        addSubview(topImageContainerView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        topImageContainerView.addSubview(bearImageView)
        bearImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        bearImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        bearImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor).isActive = true
        
        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        
        addSubview(descriptionTextView)
        
        descriptionTextView.anchor(top: topImageContainerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        descriptionTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
