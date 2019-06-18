//
//  Networking.swift
//  JogTracker
//
//  Created by Евгений Клебан on 6/17/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import Foundation

class Networking {
    
    static var accessToken = ""
    static var tokenType = ""
    
    static func login(_ uuid: String, completion: @escaping ([String: String]?, Error?) -> Void) {
        let url = URL(string: "https://jogtracker.herokuapp.com/api/v1/auth/uuidLogin?uuid=hello")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        //        let postString = "uuid=\(uuid)"
        //        request.httpBody = postString.data(using: .utf8)
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    completion(nil, error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                    let responseKeyJson = jsonResponse?["response"] as? [String: Any]
                    if let accessToken = responseKeyJson?["access_token"] as? String ,let tokenType = responseKeyJson?["token_type"] as? String {
                        
                        let dataDictionary: [String: String] = [
                            "accessToken": accessToken,
                            "tokenType": tokenType
                        ]
                        Networking.accessToken = accessToken
                        Networking.tokenType = tokenType
                        
                        completion(dataDictionary, nil)
                        
                    }
                    
                    
                }catch let error {
                    print ("Ops not good JSON formatted response")
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    static func checkJogs(_ accessToken: String, tokenType: String, completion: @escaping ([JogItem]?, Error?) -> Void) {
        let postString = "access_token=\(accessToken)&token_type=\(tokenType)"
        
        let url = URL(string: ("https://jogtracker.herokuapp.com/api/v1/data/sync?" + postString))!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        //        let postString = "access_token=\(accessToken)&token_type=\(tokenType)"
        // request.httpBody = postString.data(using: .utf8)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    completion(nil, error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                    let responseKeyJson = jsonResponse?["response"] as? [String: Any]
                    let jogs = responseKeyJson?["jogs"] as? [[String: Any]]
                    
                    var arrayOfItems: [JogItem] = []
                    
                    for jog in jogs! {
                        
                        if let id = jog["id"] as? Int, let userId = jog["user_id"] as? String, let distance = jog["distance"] as? Int,
                            let date = jog["date"] as? Int,
                            let time = jog["time"] as? Int {
                            arrayOfItems.append(JogItem(id: id, userId: userId, distance: distance, time: time, date: date))
                            
                        }
                    }
                    DispatchQueue.main.async {
                        completion(arrayOfItems, nil)
                    }
                    
                } catch let error {
                    print ("Ops not good JSON formatted response")
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    static func createNewJog(accessToken: String, tokenType: String, distance: Int, time: Int, date: String, completion: @escaping (Bool) -> Void) {
         let postString = "&date=\(date)&distance=\(distance)&time=\(time)"
        let url = URL(string: ("https://jogtracker.herokuapp.com/api/v1/data/jog?"))
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let text  = "\(tokenType) \(accessToken)"

        
        request.setValue(text, forHTTPHeaderField: "Authorization")
        
//access_token=\(accessToken)&token_type=\(tokenType)
        request.httpMethod = "POST"
        
//         request = postString.data(using: .utf8)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription)
                    completion(false)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    completion(true)
                }
            }
            task.resume()
        }
    }
}


