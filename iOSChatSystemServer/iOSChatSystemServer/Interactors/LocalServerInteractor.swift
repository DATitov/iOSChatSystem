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
            case .CreateRoom:
                return createRoom(params: params)
            }
        }()
        
        completion(text)
    }
    
    func createRoom(params: JSON) -> String {
        let user1 = User(json: params["user1"])
        let user2 = User(json: params["user2"])
        
        let room = RoomsManager().createRoom(user1: user1, user2: user2)
        let tempRoom = Room()
        tempRoom.id = room.id
        tempRoom.name = room.name
        tempRoom.user1ID = room.user1ID
        tempRoom.user2ID = room.user2ID
        guard let roomJSonString = tempRoom.toJSONString() else {
            return "{\"message\":\"failure\"}"
        }
        return "{\"room\": \(roomJSonString)}"
    }
    
    func updateUser(params: JSON) -> String {
        let user = User(json: params["params"]["user"])
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
            return updateUser(params: params)
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
        
        let rooms = RoomsManager().rooms(forUserID: id)
        
        var tempRooms = [Room]()
        for room in rooms {
            var newRoom = Room()
            newRoom.id = room.id
            newRoom.name = room.name
            newRoom.user1ID = room.user1ID
            newRoom.user2ID = room.user2ID
            tempRooms.append(newRoom)
        }
        guard let roomsJSON = tempRooms.toJSONString() else {
            return ""
        }
        SocketManager.shared.write(urlString: sender,
                                   params: [
                                    "method": ClientsMethod.Socket.ReceiveRooms.rawValue,
                                    "answer_request_uuid": requestID,
                                    "rooms": roomsJSON
            ],
                                   completion: nil)
        
        return ""
    }
    
    func loadUsers(params: JSON) -> String {
        let sender = params["params"]["sender"].stringValue
        let requestID = params["params"]["request_uuid"].stringValue
        let users = UsersManager().users()
        
        var tempUsers = [User]()
        for user in users {
            let newUser = User()
            newUser.id = user.id
            newUser.name = user.name
            tempUsers.append(newUser)
        }
        guard let usersJSON = tempUsers.toJSONString() else {
            return ""
        }
        
        SocketManager.shared.write(urlString: sender,
                                   params: [
                                    "method": ClientsMethod.Socket.ReceiveUsers.rawValue,
                                    "answer_request_uuid": requestID,
                                    "users": usersJSON
            ],
                                   completion: nil)
        
        return ""
    }
    
}
