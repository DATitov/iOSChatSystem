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

class UsersManager: NSObject {
    
    static let shared: RoomsManager = {
        let instance = RoomsManager()
        return instance
    }()
    
    let users = Variable<[User]>([User]())
    
    func addRooms(users: [User]) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(users, update: true)
        }
        
        self.users.value = Array(realm.objects(User.self))
    }

}
