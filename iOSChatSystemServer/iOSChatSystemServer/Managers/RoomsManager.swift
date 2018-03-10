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
            for user in room.usersIDs {
                if user == userID {
                    return true
                }
            }
            return false
        })
    }
    
    func createRoom(users: [User]) -> Room {
        let realm = try! Realm()
        
        let room = realm.objects(Room.self).filter { (room) -> Bool in
            if room.usersIDs.count != users.count {
                return false
            }
            for user1 in users {
                for user2 in room.usersIDs {
                    if user1.id == user2 {
                        continue
                    }
                }
                return false
            }
            return true
        }.first
        
        var userIDs = users.map({ $0.id })
        
        if let room = room {
            return room
        }else{
            let newRoom = Room()
            newRoom.name = "room"
            try! realm.write {
                realm.add(newRoom)
                newRoom.usersIDs.append(objectsIn: userIDs)
            }
            return newRoom
        }
    }
    
}
