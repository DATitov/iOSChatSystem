//  RemoteServerInteractor.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RemoteServerInteractor: NSObject {
    
    let senderURLHEaderKey = "sender_url"
    
    static let shared: RemoteServerInteractor = {
        let instance = RemoteServerInteractor()
        return instance
    }()

    func executeRequest(urlString: String, params: [String: Any], completion: @escaping ((Data?, URLResponse?, Error?) -> ())) {
        guard urlString.contains("http"),
            let url = URL(string: urlString) else {
                return completion(nil, nil, nil)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData(json: params)
        
        request.addValue(senderURLHEaderKey, forHTTPHeaderField: LocalServer.shared.serverURLString.value)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(data, response, error)
            }
            completion(data, response, error)
        }
        task.resume()
    }
    
    func jsonString(json: [String: Any]) -> String {
        var jsonString = "{"
        for (index, key) in json.keys.enumerated() {
            let value = json[key]
            var valString = ""
            if let valuJSON = value as? [String: Any] {
                valString = self.jsonString(json: valuJSON)
                jsonString.append("\n\"\(key)\":\(valString)")
            }else if let valuJSON = value as? [String: String] {
                valString = self.jsonString(json: valuJSON)
                jsonString.append("\n\"\(key)\":\(valString)")
            }else {
                valString = "\(value!)"
                jsonString.append("\n\"\(key)\":\"\(valString)\"")
            }
            if index < json.keys.count - 1 {
                jsonString.append("\n,")
            }
        }
        jsonString.append("\n}")
        
        let json = JSON(parseJSON: jsonString)
        
        return jsonString
    }
    
    func jsonData(json: [String: Any]) -> Data? {
        let jsonString = self.jsonString(json: json)
        
        let data = jsonString.data(using: String.Encoding.utf8)
        
        return data
    }
    
}
