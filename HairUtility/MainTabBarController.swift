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

            print(isStylist ?? "No is stylist set")
            
            if isStylist == false {
                
                let stylistAction = UIAlertAction(title: "Stylist", style: .default) { (action) in
                    tabBarController.selectedIndex = 1
                    self.alert(message: "", title: "Click the icon on the upper right corner to get a profile from your stylist")
                }
                let clientAction = UIAlertAction(title: "Client", style: .default) { (action) in
                    let createProfileNavController = self.templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_circle_unselected"), selectedImage: #imageLiteral(resourceName: "plus_circle"), rootViewController: ProfilePageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil))
                    self.present(createProfileNavController, animated: true, completion: nil)
                    
                }
                let actions = [stylistAction, clientAction]
                self.alertWithActions(message: "", title: "Whose phone is being used to take photos?", actions: actions)
                
            } else {
                
                //                Check here if stylist has a profile, if not redirect. Please set up your personal profile before creating a hair profile.
                //                Two ways to do this. Option 1: Ping the server \?user and see if a first name, last name are returned. Option 2: NSUserdefaults HasStylistSetUpProfile: Bool. Set default = false for very first launch, and true once successfully set up. Use option 2 because we don't want to ping the server every time someone is creating a profile.
                
                //                The problem with option 2 is that whenever someone reinstalls the app, the variabl will be reset. So in order to fix this, have the ping that the stylist checked their profile after they PATCH and when they load that view controller.
                // if is first time launchnig, stylist profile set up is false
                let createProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_circle_unselected"), selectedImage: #imageLiteral(resourceName: "plus_circle"), rootViewController: ProfilePageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil))
                self.present(createProfileNavController, animated: true, completion: nil)
                
                
            }
            
            return false
        }
        
        return true
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.isStylist = UserDefaults.standard.bool(forKey: "isStylist")
        
        let authToken = Keychain.getKey(name: "authToken")
        if authToken.isEmpty == true {
            
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
      
        
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
            homeNavController.tabBarItem.title = "Find"
        
        let profilesNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile"), rootViewController: ReplacementController(collectionViewLayout: UICollectionViewFlowLayout()))
        
          profilesNavController.tabBarItem.title = "Profiles"
        
        let createProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_circle_unselected"), selectedImage: #imageLiteral(resourceName: "plus_circle"), rootViewController: ProfilePageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil))
        
        createProfileNavController.tabBarItem.title = "Create"
        
//        let companyNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: CompanyProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
//
//
        let settingsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "settings_unselected"), selectedImage: #imageLiteral(resourceName: "settings"), rootViewController: UserSettingsController())

          settingsNavController.tabBarItem.title = "Settings"
        
        
        
        tabBar.tintColor = .black

        viewControllers = [homeNavController,
                           profilesNavController,
                           createProfileNavController,
//                           companyNavController,
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

    
