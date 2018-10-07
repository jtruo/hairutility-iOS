//
//  SwipingController.swift
//  HairLink
//
//  Created by James Truong on 11/23/17.
//  Copyright © 2017 James Truong. All rights reserved.
//

import UIKit
import KeychainAccess

class OnboardingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//  Images are loaded using paths instead of assets in order to deallocate memory.
    
 

    
    let pages = [
     
        Page(imagePath: "page1", headerText: "Discover", bodyText: "Find detailed information about any hairstyle from our massive library!"),
        Page(imagePath: "page3", headerText: "Connect", bodyText: "Access our tool for finding local hairstylists that best suit your needs"),
        Page(imagePath: "page4", headerText: "Communicate", bodyText: "Save detailed information about your own hairstyle so your stylist can understand exactly what you want"),
     
    ]
    
    lazy var signupButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        button.backgroundColor = UIColor(red: 31/255, green: 182/255, blue: 255/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 30
        
        
        
        button.addTarget(self, action: #selector (signupButtonTapped), for: .touchUpInside)

        
        return button
        
    }()
    
    
    
    @objc func signupButtonTapped() {
        
        let signupController = SignUpController()
        
        self.navigationController?.pushViewController(signupController, animated: true)
        print("Sign Up button function is working")
        
        
    }
    
    
    lazy var loginButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(red: 163/255, green: 173/255, blue: 180/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        button.backgroundColor = UIColor.rgb(red: 252, green: 252, blue: 252)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector (loginButtonTapped), for: .touchUpInside)
        
        return button
        
    }()
    
    @objc func loginButtonTapped() {
        let loginController = LoginController()
        
        self.navigationController?.pushViewController(loginController, animated: true)
        print("Login button function is working")
        
    }
    
    lazy var getMeStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try the app!", for: .normal)
        button.setTitleColor(UIColor(red: 20/255, green: 20/255, blue: 240/255, alpha: 0.8), for: .normal)
        button.addTarget(self, action: #selector(getMeStarted), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func getMeStarted() {
//        print("Will dismiss OnboardingVC")
//        let keychain = Keychain(service: "com.HairLinkCustom.HairLink")
//        let token = try? keychain.getString("authToken")
//        print(token!)
        
//        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
//
//        mainTabBarController.setupViewControllers()
        
//        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
   
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .red
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        
        return pc
    }()
    

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        
        
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.showsHorizontalScrollIndicator = false 
        collectionView?.isPagingEnabled = true
        
        setupBottomControls()
    }
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        }) { (_) in
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    

    func setupBottomControls() {
        
        
        
    let bottomContainerView = UIView()
    bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        
    
    view.addSubview(bottomContainerView)
        
    bottomContainerView.addSubview(pageControl)
    bottomContainerView.addSubview(signupButton)
    bottomContainerView.addSubview(loginButton)
    bottomContainerView.addSubview(getMeStartedButton)
    
        // Figure out how to constrain the bottomContainerview to the description textview
        
    bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    bottomContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
    
    pageControl.anchor(top: bottomContainerView.topAnchor, left: bottomContainerView.leftAnchor, bottom: signupButton.topAnchor, right: bottomContainerView.rightAnchor, paddingTop: -12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    signupButton.anchor(top: pageControl.bottomAnchor, left: nil, bottom: loginButton.topAnchor, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 300, height: 60)
    loginButton.anchor(top: signupButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 300, height: 60)
    getMeStartedButton.anchor(top: loginButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 20)
    
    
    signupButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
    loginButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
    getMeStartedButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        

        
    }
    
    
}

