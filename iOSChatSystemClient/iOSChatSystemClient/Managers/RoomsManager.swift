//
//  RoomsManager.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import Realm
import RealmSwift

class RoomsManager: NSObject {
    
    static let shared: RoomsManager = {
        let instance = RoomsManager()
        return instance
    }()
    
    let rooms = Variable<[Room]>([Room]())
    
    func addRooms(rooms: [Room]) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(rooms, update: true)
        }
        
        self.rooms.value = Array(realm.objects(Room.self))
    }
    
}
