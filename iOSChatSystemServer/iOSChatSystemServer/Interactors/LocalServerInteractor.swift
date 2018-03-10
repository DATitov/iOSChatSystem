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
            case .GetUser:
                return getUser(params: params)
            case .Unknown:
                return ""
            case .UpdateUser:
                return updateUser(params: params)
            }
        }()
        
        completion(text)
    }
    
    func updateUser(params: JSON) -> String {
        let user = User(json: params["user"])
        UsersManager().addUser(user: user)
        
        return "{\"message\":\"updated\"}"
    }
    
    func getUser(params: JSON) -> String {
        let userID = params["params"]["user_id"].stringValue
        let user = { () -> User in
            if let user = UsersManager().user(forID: userID) {
                return user
            }else{
                let user = User()
                user.id = userID
                UsersManager().addUser(user: user)
                return user
            }
        }()
        
        let newUser = User()
        newUser.id = user.id
        newUser.name = user.name
        
        guard let userJson = newUser.toJSONString() else {
            return ""
        }
        return "{\"user\":\(userJson)}"
    }
    
    func receiveMessage(params: JSON) -> String {
        let method = params["params"]["method"].stringValue
        switch ServerMethod.Socket(rawValue: method) ?? ServerMethod.Socket.Unknown {
        case .LoadRooms:
            return loadRooms(params: params)
        case .UpdateUser:
            return ""
        case .Unknown:
            return ""
        case .LoadUsers:
            return loadUsers(params: params)
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
        let id = params["params"]["user_id"].stringValue
        let sender = params["params"]["sender"].stringValue
        let requestID = params["params"]["request_uuid"].stringValue
        
        guard let rooms = RoomsManager().rooms(forUserID: id).toJSONString() else {
            return ""
        }
        SocketManager.shared.write(urlString: sender,
                                   params: [
                                    "method": ClientsMethod.Socket.ReceiveRooms.rawValue,
                                    "answer_request_uuid": requestID,
                                    "rooms": rooms
            ],
                                   completion: nil)
        
        return ""
    }
    
    func loadUsers(params: JSON) -> String {
        let sender = params["params"]["sender"].stringValue
        let requestID = params["params"]["request_uuid"].stringValue
        guard let users = UsersManager().users().toJSONString() else {
            return ""
        }
        
        SocketManager.shared.write(urlString: sender,
                                   params: [
                                    "method": ClientsMethod.Socket.ReceiveUsers.rawValue,
                                    "answer_request_uuid": requestID,
                                    "users": users
            ],
                                   completion: nil)
        
        return ""
    }
    
}
