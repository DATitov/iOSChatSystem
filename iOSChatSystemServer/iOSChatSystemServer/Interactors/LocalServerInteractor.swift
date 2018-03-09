//
//  LocalServerInteractor.swift
//  iOSChatSystemServer
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
        execute(method: ServerMethod(rawValue: method) ?? ServerMethod.Unknown, params: params, completion: completion)
    }
    
    private func execute(method: ServerMethod, params: JSON, completion: ((String) -> ())) {
        let text = { () -> String in
            switch method {
            case .ConnectClient:
                return connectClient(params: params)
            case .ConnectServerManager:
                return receiveMessage(params: params)
            case .Ping:
                return "pong"
            case .ReceiveMessage:
                return receiveMessage(params: params)
            case .Unknown:
                return ""
            }
        }()
        
        completion(text)
    }
    
    func receiveMessage(params: JSON) -> String {
        let method = params["method"].stringValue
        switch ServerMethod.Socket(rawValue: method) ?? ServerMethod.Socket.Unknown {
        case .LoadRooms:
            return loadRooms(params: params)
        case .UpdateUser:
            return ""
        case .Unknown:
            return ""
        }
    }
    
    func connectClient(params: JSON) -> String {
        let client = Client(withJSON: params)
        ClientsManager.shared.addClient(client: client)
        
        return "{\"message\":\"connected\"}"
    }
    
    func connectServerManager(params: JSON) -> String {
        let server = Server(withJSON: params)
        return "{\"message\":\"connected\"}"
    }
    
    func loadRooms(params: JSON) -> String {
        let user = User()
        
        return ""
    }
    
}
