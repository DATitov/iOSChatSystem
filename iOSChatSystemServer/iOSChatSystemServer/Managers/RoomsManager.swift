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
        
        return realm.objects(Room.self).filter({ $0.user1ID == userID || $0.user2ID == userID})
    }
    
    func createRoom(user1: User, user2: User) -> Room {
        let realm = try! Realm()
        
        let room = realm.objects(Room.self).filter { (room) -> Bool in
            return (room.user1ID == user1.id && room.user2ID == user2.id) || (room.user2ID == user1.id && room.user1ID == user2.id)
        }.first
        
        
        if let room = room {
            return room
        }else{
            let newRoom = Room()
            newRoom.name = "room"
            newRoom.user1ID = user1.id
            newRoom.user2ID = user2.id
            try! realm.write {
                realm.add(newRoom)
            }
            return newRoom
        }
    }
    
}
