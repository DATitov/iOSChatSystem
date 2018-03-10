//
//  UsersManager.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import Realm
import RealmSwift
import SwiftyJSON

class UsersManager: NSObject {
    
    static let shared: UsersManager = {
        let instance = UsersManager()
        return instance
    }()
    
    let users = Variable<[User]>([User]())
    let usersNames = Variable<[String]>([String]())
    var currentUser: User?
    
    override init() {
        super.init()
        
        DispatchQueue.main.async {
            let realm = try! Realm()
            var tempUSers = [User]()
            for u in Array(realm.objects(User.self)) {
                let user = User()
                user.name = u.name
                user.id = u.id
                tempUSers.append(user)
            }
            self.users.value = tempUSers
            
            let tempUser = realm.objects(User.self).first ?? { () -> User in
                let user = User()
                user.id = LocalServer.shared.serverURLString.value
                return user
                }()
            
            self.currentUser = User()
            self.currentUser?.name = tempUser.name
            self.currentUser?.id = tempUser.id
        }
    }
    
    func getCurrentUser() -> User {
        let realm = try! Realm()
        guard let curUser = realm.objects(User.self).filter( {$0.id == LocalServer.shared.serverURLString.value} ).first else {
            return User()
        }
        let newUser = User()
        
        newUser.id = curUser.id
        newUser.name = curUser.name
        
        return newUser
    }
    
    
    func addUsers(users: [User]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(users)
        }
        
        self.users.value = Array(realm.objects(User.self))
    }
    
    func getUser() {
        RemoteServerInteractor.shared.executeRequest(urlString: ServerInteractor.shared.serverURLString.value,
                                                     params: ["method": ServerMethod.GetUser.rawValue,
                                                              "params":
                                                                [
                                                                    "user_id": LocalServer.shared.serverURLString.value
                                                                    ] as [String: Any]
        ]) { (data, response, error) in
            guard let data = data,
                let string = String(data: data, encoding: .utf8) else {
                    return
            }
            let user = User(json: JSON(parseJSON: string)["user"])
            self.updateLocalUser(user: user)
        }
    }
    
    func updateUser(user: User) {
        RemoteServerInteractor.shared.executeRequest(urlString: ServerInteractor.shared.serverURLString.value,
                                                     params: ["method": ServerMethod.ReceiveMessage.rawValue,
                                                              "params": [
                                                                "method": ServerMethod.Socket.UpdateUser.rawValue,
                                                                "user":
                                                                    [
                                                                        "id": user.id,
                                                                        "name": user.name
                                                                        ] as [String: Any]
                                                        ]
        ]) { (data, response, error) in
            if error == nil {
                self.updateLocalUser(user: user)
            }
        }
    }
    
    func loadUsers() {
        SocketManager.shared.write(urlString: ServerInteractor.shared.serverURLString.value,
                                   params: [
                                    "method": ServerMethod.Socket.LoadUsers.rawValue,
                                    "sender": LocalServer.shared.serverURLString.value
        ]) { (json) in
            guard let json = json else {
                return
            }
            
            var users = [User]()
            for rawUser in json["users"].arrayValue {
                let user = User(json: rawUser)
                users.append(user)
            }
            self.storeUsers(users: users)
        }
    }
    
    func updateLocalUser(user: User) {
        let realm = try! Realm()
        let storedUser = realm.objects(User.self).filter({ $0.id == LocalServer.shared.serverURLString.value }).first
        try! realm.write {
            if let storedUser = storedUser {
                storedUser.name = user.name
            }else{
                realm.add(user)
            }
        }
        self.currentUser = user
    }
    
    func storeUsers(users: [User]) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(realm.objects(User.self))
            realm.add(users)
        }
        
        var tempUSers = [User]()
        for u in Array(realm.objects(User.self)) {
            
            let user = User()
            user.name = u.name
            user.id = u.id
            tempUSers.append(user)
        }
        DispatchQueue.main.async {
            self.users.value = tempUSers
        }
        
        var names = [String]()
        for u in tempUSers {
            var text = u.name
            if text.count < 1 {
                text = u.id
            }
            names.append(text)
        }
        self.usersNames.value = names
    }
    
    func user(forID id: String) -> User? {
        let realm = try! Realm()
        let user = realm.objects(User.self).filter({ $0.id == id }).first
        guard let u = user else {
            return nil
        }
        
        let newUser = User()
        newUser.id = u.id
        newUser.name = u.name
        return newUser
    }

}
