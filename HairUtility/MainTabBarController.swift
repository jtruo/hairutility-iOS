//
//  MainTabBarController.swift
//  HairUtility
//
//  Created by James Truong on 10/2/16.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import KeychainAccess

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var isStylist: Bool?
    var authToken: String?
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {

            if isStylist == false {
                
                let stylistAction = UIAlertAction(title: "Stylist", style: .default) { (action) in
                    tabBarController.selectedIndex = 1
                }
                let clientAction = UIAlertAction(title: "Client", style: .default) { (action) in
                    let hairProfileCreationController = CreateHairProfileController()
                    self.present(hairProfileCreationController, animated: true)
                }
                let actions = [stylistAction, clientAction]
                self.alertWithActions(message: "", title: "Whose phone is being used to take photos?", actions: actions)
                
            } else {
                let hairProfileCreationController = CreateHairProfileController()
                self.present(hairProfileCreationController, animated: true)
            }
            
            return false
        }
        
        return true
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.isStylist = UserDefaults.standard.bool(forKey: "isStylist")
        
        Keychain.getAuthToken { (authToken) in
            self.authToken = authToken
        }
        
        if authToken?.isEmpty ?? true {
            
            print("Loading Onboarding Controller")
            DispatchQueue.main.async {
                
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .horizontal
                
                let onboardingController = OnboardingController(collectionViewLayout: layout)
                let navController = UINavigationController(rootViewController: onboardingController)
                self.present(navController, animated: false, completion: nil)
                
            }
            return
        }
        
        
        setupViewControllers()
       
    }
    
    func setupViewControllers() {
      
        
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let profilesNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: ReplacementController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let createProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        createProfileNavController.view.backgroundColor = .blue
       
        let companyNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: CompanyProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        let settingsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "gear"), selectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: UserSettingsController())

        tabBar.tintColor = .black
    
        viewControllers = [homeNavController,
                           profilesNavController,
                           createProfileNavController,
                           companyNavController,
                           settingsNavController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
   
        
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }

}

    
