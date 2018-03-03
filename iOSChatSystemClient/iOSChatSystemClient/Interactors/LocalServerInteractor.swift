//
//  LocalServerInteractor.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import SwiftyJSON

class LocalServerInteractor: NSObject {
    
    enum Method: String {
        case Connect = "Connect"
        case Unknown = "Unknown"
    }
    
    static let shared: LocalServerInteractor = {
        let instance = LocalServerInteractor()
        return instance
    }()
    
    func execute(method: String, params: JSON, completion: ((String) -> ())) {
        execute(method: Method(rawValue: method) ?? Method.Unknown, params: params, completion: completion)
    }
    
    private func execute(method: Method, params: JSON, completion: ((String) -> ())) {
        let text = { () -> String in
            switch method {
            case .Connect:
                return ""
            case .Unknown:
                return ""
            }
        }()
        
        completion(text)
    }

}
