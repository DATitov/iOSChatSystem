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
        if let su = storedUser {
            su.name = user.name
        }
        
        try! realm.write {
            if let storedUser = storedUser {
                realm.add(storedUser, update: true)
            }else{
                realm.add(user)
            }
        }
    }
    
}
