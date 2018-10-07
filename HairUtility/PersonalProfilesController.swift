//
//  PersonalProfilesController.swift
//  HairLink
//
//  Created by James Truong on 6/21/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess

class PersonalProfilesController: UIViewController, UITableViewDelegate, UITableViewDataSource, GetHairstyleDelegate {
  

    private let cellId = "cellId"
    var isStylist: Bool?
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        tv.delegate = self
        tv.dataSource = self
        tv.register(PersonalProfileCell.self, forCellReuseIdentifier: self.cellId)
        return tv
    }()
    
    lazy var addProfileButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_unselected"), for: .normal)
        button.addTarget(self, action: #selector(addProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func addProfileButtonTapped() {
        
        if isStylist == false {
        
        let stylistAction = UIAlertAction(title: "Stylist", style: .default) { (action) in
            let getHairstyleView = GetHairstyleView()
            getHairstyleView.delegate = self
            getHairstyleView.show(animated: true)
        }
        let clientAction = UIAlertAction(title: "Client", style: .default) { (action) in
            let hairProfileCreationController = CreateHairProfileController()
            self.navigationController?.present(hairProfileCreationController, animated: true)
        }
        let actions = [stylistAction, clientAction]
        self.alertWithActions(message: "", title: "Whose phone is being used to take photos?", actions: actions)
            
        } else {
            let hairProfileCreationController = CreateHairProfileController()
            self.navigationController?.present(hairProfileCreationController, animated: true)
        }

    }
    

    

//
//        self.appendingUrl = "api/v1/hairprofiles/?user"
//        print(self.appendingUrl)
//        getUserHairProfiles()
    
 

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hairProfiles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PersonalProfileCell
        cell.hairProfile = hairProfiles[indexPath.item]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editHairProfileController = EditHairProfileController()
        editHairProfileController.hairProfile = hairProfiles[indexPath.item]
        self.navigationController?.pushViewController(editHairProfileController, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightNavBarButton = UIBarButtonItem(customView: addProfileButton)
        self.navigationItem.rightBarButtonItem = rightNavBarButton

        
        Keychain.getAuthToken { (authToken) in
            self.authToken = authToken
        }
        self.isStylist = UserDefaults.standard.bool(forKey: "isStylist")

        title = "Profiles"
        view.backgroundColor = .white
        view.addSubview(tableView)
        setupAutoLayout()
        
    }
    
    func setupAutoLayout() {
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func downloadButtonTapped(appendingUrl: String) {
        self.appendingUrl = appendingUrl
        getUserHairProfiles()
    }
    

    var authToken: String?
    var hairProfiles = [HairProfile]()
    var appendingUrl = ""
    var hairProfileToSave: HairProfile?
    
    func getUserHairProfiles() {
    
        guard let authToken = authToken else { return }
  
        let headers: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]

        print("The data request is \(appendingUrl)")
        Alamofire.DataRequest.userRequest(requestType: "GET", appendingUrl: appendingUrl, headers: headers, parameters: nil, success: { (apiResult) in
            guard let apiResult = apiResult as? RawApiResponse else { return }
    
 
            print(apiResult.results.count)
            print(self.appendingUrl)
            apiResult.results.forEach({ (hairprofile) in
                self.hairProfiles.append(hairprofile)
            })
            
            if self.appendingUrl != "api/v1/hairprofiles/?user" {
                self.hairProfileToSave = apiResult.results[0]
                self.postHairProfile()
            }
            
            self.tableView.reloadData()

        }) { (Error) in
            print(Error)
            self.alert(message: "There was an error saving the profile")
        }
    }
    
    
    func postHairProfile() {
        print("Posting hair profile")
  
        guard let authToken = authToken else { return }
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Token \(authToken)"
        ]
        
        guard let hairProfileToSave = hairProfileToSave else { return }
        
        print("Hairprofile to save was passed")
        
        let parameters: [String: Any] = [
            "creator": hairProfileToSave.creator,
            "hairstyle_name": hairProfileToSave.hairstyleName,
            "first_image_url": hairProfileToSave.firstImageUrl,
            "second_image_url": hairProfileToSave.secondImageUrl,
            "third_image_url": hairProfileToSave.thirdImageUrl,
            "fourth_image_url": hairProfileToSave.fourthImageUrl,
            "profile_description": hairProfileToSave.profileDescription,
            "is_displayable": false,
        ]
        
        print(parameters)
        Alamofire.DataRequest.userRequest(requestType: "POST", appendingUrl: "api/v1/hairprofiles/", headers: headers, parameters: parameters, success: { (hairProfiles) in
            
            print("finished")
            self.alert(message: "Successfully saved profiles to your account")
        }) { (err) in
            print(err)
            self.alert(message: "There was an error with saving the profile")
        }
    }
    
}
