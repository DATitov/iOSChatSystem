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
    
    static let shared: LocalServerInteractor = {
        let instance = LocalServerInteractor()
        return instance
    }()
    
    func execute(method: String, params: JSON, completion: ((String) -> ())) {
        execute(method: ClientsMethod(rawValue: method) ?? ClientsMethod.Unknown, params: params, completion: completion)
    }
    
    private func execute(method: ClientsMethod, params: JSON, completion: ((String) -> ())) {
        let text = { () -> String in
            switch method {
            case .Unknown:
                return ""
            case .ReceiveMessage:
                return ""
            case .SocketReceiveRooms:
                return receiveRooms(params: params)
            case .Ping:
                return "{\"message\":\"pong\"}"
            }
        }()
        
        completion(text)
    }
    
    func receiveRooms(params: JSON) -> String {
        
        let rooms = params["rooms"].arrayValue
        
        return ""
    }

}
