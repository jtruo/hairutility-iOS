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
        Page(imagePath: "page2", headerText: "Connect", bodyText: "Access our tool for finding local hairstylists that best suit your needs"),
        Page(imagePath: "page3", headerText: "Communicate", bodyText: "Save detailed information about your own hairstyle so your stylist can understand exactly what you want"),
     
    ]
    
    lazy var signupButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        button.backgroundColor = UIColor.mainCharcoal()
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
        button.setTitleColor(UIColor.mainCharcoal(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        button.backgroundColor = UIColor.rgb(red: 252, green: 252, blue: 252)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.mainCharcoal().cgColor
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
        pc.currentPageIndicatorTintColor = UIColor.mainCharcoal()
        pc.pageIndicatorTintColor = UIColor.mainGrey()
        pc.isUserInteractionEnabled = false
        return pc
    }()
    

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationController?.navigationBar.backgroundColor = .clear
        
        
        collectionView?.contentInset = UIEdgeInsets(top: UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0, left: 0, bottom: UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0, right: 0)
        
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

    
        // Figure out how to constrain the bottomContainerview to the description textview
        
    bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    bottomContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
    
       
    
        
    pageControl.anchor(top: bottomContainerView.topAnchor, leading: bottomContainerView.leadingAnchor, bottom: nil, trailing: bottomContainerView.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 50))
        
    signupButton.anchor(top: pageControl.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 4, right: 0), size: .init(width: 300, height: 60))
    
    loginButton.anchor(top: signupButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 60))
    

    
    signupButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
    loginButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true


        
    }
    
    
}

