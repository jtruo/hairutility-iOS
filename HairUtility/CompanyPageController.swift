//
//  CreateCompanyPageController.swift
//  HairLink
//
//  Created by James Truong on 8/3/18.
//  Copyright © 2018 James Truong. All rights reserved.
//


import UIKit
import IQKeyboardManagerSwift
import KeychainAccess
import Alamofire


class CompanyPageController: UIPageViewController, UIPageViewControllerDelegate, FirstPageDelegate {

    
    
    var pages = [UIViewController]()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = self.pages.count
        pageControl.isUserInteractionEnabled = false
        
        return pageControl
    }()
    
    lazy var dismissButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "download"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    @objc func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
        
    
    fileprivate var returnHandler : IQKeyboardReturnKeyHandler!
    
    init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
//    Add a button. Changes text of the button. If button is pressed and the page index is 1, then send the information through delegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let firstPage = FirstPageController()
        firstPage.delegate = self
        let secondPage = SecondPageController()
        self.pages.append(firstPage)
        self.pages.append(secondPage)
        
        let initialPage = 0
        pageControl.currentPage = initialPage
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    
        let leftBarButton = UIBarButtonItem(customView: dismissButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationController?.navigationBar.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [pageControl])
        stackView.axis = .horizontal
        stackView.spacing = 20
        
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        returnHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnHandler.lastTextFieldReturnKeyType = .default
        
        
 
    }
    
    @objc func nextButtonPressed() {
        print("Something")
        setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = 1
        
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
