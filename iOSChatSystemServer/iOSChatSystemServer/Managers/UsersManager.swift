//
//  UsersManager.swift
//  iOSChatSystemServer
//
//  Created by Dmitrii Titov on 10.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class UsersManager: NSObject {
    
    func join(users: [User]) {
        let realm = try! Realm()
        let storedUsers = realm.objects(User.self)
        
        var usersToJoin = [User]()
        for user in users {
            var stored = false
            for stUser in storedUsers {
                if stUser.id == user.id {
                    stored = true
                    break
                }
            }
            if !stored {
                usersToJoin.append(user)
            }
        }
        
        try! realm.write {
            realm.add(usersToJoin)
        }
    }

    func users() -> [User] {
        let realm = try! Realm()
        
        return Array(realm.objects(User.self))
    }
    
    func user(forID id: String) -> User? {
        let realm = try! Realm()
        
        return Array(realm.objects(User.self)).filter({ $0.id == id }).first
    }
    
    func addUser(user: User) {
        let realm = try! Realm()
        
        let storedUser = realm.objects(User.self).filter { (u) -> Bool in
            return user.id == u.id
        }.first
        
        try! realm.write {
            if let storedUser = storedUser {
                storedUser.name = user.name
            }else{
                realm.add(user)
            }
        }
    }
    
}
