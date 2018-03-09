//
//  RoomsManager.swift
//  iOSChatSystemServer
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class RoomsManager: NSObject {

    func rooms(forUserID userID: String) -> [Room] {
        let realm = try! Realm()
        
        return realm.objects(Room.self).filter({ (room) -> Bool in
            for user in room.users {
                if user.id == userID {
                    return true
                }
            }
            return false
        })
    }
    
}
