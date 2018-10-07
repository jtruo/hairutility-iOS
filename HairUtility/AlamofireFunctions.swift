
//
//  HelperFunctions.swift
//  HairLink
//
//  Created by James Truong on 6/18/18.
//  Copyright © 2018 James Truong. All rights reserved.
//

import Foundation
import Alamofire


extension DataRequest {
    //    When extra headers is nil. All HTTP header fields become nil. To reduce code, only set the Token header as a parameter. Or code to headers
    // Change base url from http to https
    
    static let baseUrl = "https://hairutility-qa.herokuapp.com/"
    
    static func userRequest(requestType: String, appendingUrl: String, headers: [String: String]?, parameters: [String: Any]?, success:@escaping (Any?) -> Void, failure:@escaping (String) -> Void){
        
        print(baseUrl)
        
        
        let encodedUrl = appendingUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let combinedString = baseUrl + encodedUrl!
        
        print(combinedString)
        
        
        guard let url = URL(string: combinedString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType
        urlRequest.allHTTPHeaderFields = headers
        
        
        if parameters != nil {
            
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: [])
            } catch let error {
                print(error)
            }
            
        }
        
        Alamofire.request(urlRequest).validate()
            
            .responseData { (response) in
                
                //Add response string for error code. Each case acts like a router for what object should be return based on the  api
                switch response.result {
                case.success:
                    print("Success")
                    
                    guard let data = response.result.value else { return print("Data not casted") }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    switch appendingUrl {
                        
                    case "api/v1/hairprofiles/":
                        success(nil)
                        print("Successfully saved profile")
                        
                    case let str where str.contains("/hairprofiles/?"):
                        
                        do {
                            debugPrint(response)
                            let hairProfile = try decoder.decode(RawApiResponse.self, from: data)
                            success(hairProfile)
                        } catch let error {
                            print("Error converting hairprofile json: \(error)")
                        }
                        
                    case let str where str.contains("/hairprofiles/?"):
                        
                        do {
                            debugPrint(response)
                            let hairProfile = try decoder.decode(RawApiResponse.self, from: data)
                            success(hairProfile)
                        } catch let error {
                            print("Error converting hairprofile json: \(error)")
                        }
                        
                    case let str where str.contains("users") || str.contains("api-token-auth"):
                        
                        do {
                            let user = try decoder.decode(User.self, from: data)
                            success(user)
                            
                        } catch let error {
                            print("Error converting json: \(error)")
                            
                        }
                        
                        print("User request succeeded")
                        
                    case let str where str.contains("api/v1/companies/"):
                        
                        do {
                            
                            let company = try decoder.decode(Company.self, from: data)
                            success(company)
                            
                        } catch let error {
                            print("Error converting json: \(error)")
                        }
                        
                    default:
                        debugPrint(response)
                        print("There is no object that is returned from the url")
                        break
                        
                    }
                    
                case.failure:
                    print("Do nothing")
                }
        }
            .responseString { (response) in
                switch response.result {
                case.success:
                    print("Successfully")
                case.failure:
                    guard let responseData = response.data else { return}
                    guard let responseString = String(data: responseData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "[\\[\\]\\}\\{\".]", with: "", options: .regularExpression, range: nil) else { return }
//            Or do not do this. Make sure the fields are validated before submitting
                    debugPrint(response)
                    failure("Error: \(responseString)")
                }
        }
        
  
        }
        
    }
    



