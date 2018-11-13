//
//  Extensions.swift
//  HairLink
//
//  Created by James Truong on 7/24/17.
//  Copyright © 2017 James Truong. All rights reserved.
//

import UIKit
import KeychainAccess
import ImagePicker


extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
 
    
    static func mainBlue() -> UIColor {
        return UIColor.rgb(red: 74, green: 162, blue: 249)
    }
    
}

// Sets all constraints and frames

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {

        translatesAutoresizingMaskIntoConstraints = false


        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}



extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


//extension UIView {
//
//    func constraintsAligningAllEdges(toView view2: UIView) -> [NSLayoutConstraint] {
//
//        return [ topAnchor.constraint(equalTo: view2.topAnchor),
//                 bottomAnchor.constraint(equalTo: view2.bottomAnchor),
//                 leadingAnchor.constraint(equalTo: view2.leadingAnchor),
//                 trailingAnchor.constraint(equalTo: view2.trailingAnchor) ]
//    }
//}

//Prevents repeated presses

extension UIButton {
    func preventRepeatedPresses(inNext seconds: Double = 0.75) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
}

// Quick alert extension

extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertWithActions(message: String, title: String = "", actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for index in 0..<actions.count {
            alertController.addAction(actions[index])
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

// Pop up an alert from a UIVIEW

extension UIView {
    
    func alertUIView(message: String, title: String = "", actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        print(actions.count)
        for index in 0..<actions.count {
            alertController.addAction(actions[index])
        }
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)

    }
}



extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}


enum UserDefaultsKeys : String {
    case isStylist
    case isActive
    case pk
    case email
    
}


extension UserDefaults{
    
    //MARK: Check Login
    func setIsStylist(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isStylist.rawValue)
        //synchronize()
    }
    
    func setIsActiveIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isActive.rawValue)
    }
    
    //MARK: Save User Data
    func setStylistPk(value: Int){
        set(value, forKey: UserDefaultsKeys.pk.rawValue)
        //synchronize()
    }
    
    
    //MARK: Retrieve User Data
    func getUserID() -> Int{
        return integer(forKey: UserDefaultsKeys.pk.rawValue)
    }
    
    func getIsStylist() -> Bool{
        return bool(forKey: UserDefaultsKeys.isStylist.rawValue)
    }
}




//MARK: Keychain


extension Keychain {
    
    static let keychain = Keychain(service: "com.HairLinkCustom.HairLink")
    
    static func getAuthToken(completion: @escaping (String) -> Void)  {
        var authToken: String?
        
        do {
            authToken = try self.keychain.get("authToken")
        } catch let error {
            print("Error: \(error)")
        }
        
        if authToken?.isEmpty ?? true {
            print("Token is empty")
        } else {
            completion(authToken!)
        }
        
    }
    
    static func getPk(completion: @escaping (String) -> Void) {
        var pk: String?
        
        do {
            pk = try self.keychain.get("pk")
        } catch let error {
            print("Error: \(error)")
        }
        
        if pk?.isEmpty ?? true {
            print("PK is empty")
        } else {
            completion(pk!)
        }

    }
    
    static func getKeychainValue(name: String, completion: @escaping (String) -> Void) {
        
        var result: String?
        
        do {
            result = try self.keychain.get(name)
        } catch let error {
            print("Error: \(error)")
   
        }
        
        if result?.isEmpty ?? true {
            print("PK is empty")
//            Return signal the error
        } else {
            completion(result!)
        }
    }
    
}


//func randomString(length: Int) -> String {
//    
//    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//    let length = UInt32(letters.length)
//    
//    var randomString = ""
//    
//    for _ in 0 ..< length {
//        let rand = arc4random_uniform(length)
//        var nextChar = letters.character(at: Int(rand))
//        randomString += NSString(characters: &nextChar, length: 1) as String
//    }
//    
//    return randomString
//}

   /// Returns the element at the specified index if it is within bounds, otherwise nil.

extension Collection {
    
 
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
        sendActions(for: UIControlEvents.valueChanged)
    }
}


// Text field extension for drawing a line under the text field
// It is the only extension that allows for resizing/auto-layout
// Change colors by calling the borders function again with a different color

extension UIView {
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .lightGray) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
}


// Allows for multiple characters of a string to be replaced in one line






// Moves when keyboard shows up


extension Array where Element: Equatable {
    @discardableResult
    mutating func appendIfValueDoesNotExist(_ element: Element) -> Bool {
        if !contains(element) {
            append(element)
            return true
        }
        return false
    }
}


// Removes images at document directory

func removeImage(itemName:String, fileExtension: String) {
    let fileManager = FileManager.default
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    guard let dirPath = paths.first else {
        return
    }
    let filePath = "\(dirPath)/\(itemName).\(fileExtension)"
    do {
        try fileManager.removeItem(atPath: filePath)
    } catch let error as NSError {
        print(error.debugDescription)
    }}

//Converts date to string
extension Date
{
    func convertDateToString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
