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
import SwiftyJSON

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
    
    func updateRooms() {
        SocketManager.shared.write(urlString: ServerInteractor.shared.serverURLString.value,
                                   params: ["method": ServerMethod.Socket.LoadRooms.rawValue,
                                            "sender": LocalServer.shared.serverURLString.value,
                                            "user_id": UsersManager.shared.currentUser.id],
                                   completion: { json in
                                    guard let json = json else {
                                        return
                                    }
                                    
                                    self.joinRawRooms(rawRooms: json["rooms"].arrayValue)
                                    print("")
        })
    }
    
    func joinRawRooms(rawRooms: [JSON]) {
        var rooms = [Room]()
        for rawRoom in rawRooms {
            rooms.append(Room(withJSON: rawRoom))
        }
        
        self.rooms.value = rooms
    }
    
}
