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
    
    lazy var currentUser = { () -> User in
        let realm = try! Realm()
        return realm.objects(User.self).first ?? { () -> User in
            let user = User()
            user.id = LocalServer.shared.serverURLString.value
            return user
            }()
    }()
    
    func addUsers(users: [User]) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(users, update: true)
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
                                                              "user":
                                                                [
                                                                    "id": user.id,
                                                                    "name": user.name
                                                                    ] as [String: Any]
        ]) { (data, response, error) in
            
        }
    }
    
    func updateLocalUser(user: User) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
        self.currentUser = user
    }

}
