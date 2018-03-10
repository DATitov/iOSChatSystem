//
//  LocalServerInteractor.swift
//  iOSChatSystemServerManager
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Cocoa
import SwiftyJSON

class LocalServerInteractor: NSObject {
    
    static let shared: LocalServerInteractor = {
        let instance = LocalServerInteractor()
        return instance
    }()
    
    func execute(method: String, params: JSON, completion: ((String) -> ())) {
        execute(method: ServerManagerMethod(rawValue: method) ?? ServerManagerMethod.Unknown, params: params, completion: completion)
    }
    
    private func execute(method: ServerManagerMethod, params: JSON, completion: ((String) -> ())) {
        let text = { () -> String in
            switch method {
            case .ConnectClient:
                return connectClient(params: params)
            case .ConnectToServer:
                return connectToServer(params: params)
            case .ConnectServer:
                return connectServer(params: params)
            case .Ping:
                return "Pong"
            case .Unknown: 
                return ""
            }
        }()
        
        completion(text)
    }
    
    func connectClient(params: JSON) -> String {
        let client = Client(withJSON: params["client"])
        ClientsManager.shared.addClient(client: client)
        return "{\"message\": \"connected\"}"
    }
    
    func connectToServer(params: JSON) -> String {
        let client = Client(withJSON: params["client"])
        guard let serverURLString = ServersManager.shared.connectClient(client: client) else {
            return "{\"message\": \"No servers available\"}"
        }
        
        return "{\"server_url\": \"\(serverURLString)\"}"
    }
    
    func connectServer(params: JSON) -> String {
        let server = Server(withJSON: params["server"])
        
        ServersManager.shared.addServer(server: server)
        
        return "{\"message\": \"connected\"}"
    }
    
}
