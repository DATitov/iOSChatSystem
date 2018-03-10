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
            realm.add(rooms)
        }
        
        self.rooms.value = Array(realm.objects(Room.self))
    }
    
    func updateRooms() {
        let params = ["method": ServerMethod.Socket.LoadRooms.rawValue,
                      "sender": LocalServer.shared.serverURLString.value,
                      "user_id": LocalServer.shared.serverURLString.value]
        
        SocketManager.shared.write(urlString: ServerInteractor.shared.serverURLString.value,
                                   params: params,
                                   completion: { json in
                                    guard let json = json else {
                                        return
                                    }
                                    
                                    self.joinRawRooms(rawRooms: json["rooms"].arrayValue)
        })
    }
    
    func createRoom(withUSer user: User, completion: @escaping ((Room?) -> ())) {
        RemoteServerInteractor.shared.executeRequest(urlString: ServerInteractor.shared.serverURLString.value,
                                                     params: [
                                                        "method": ServerMethod.CreateRoom.rawValue,
                                                        "user1": user.toJSONString()!,
                                                        "user2": user.toJSONString()!
        ]) { (data, response, error) in
            guard let data = data,
                let string = String(data: data, encoding: .utf8) else {
                    return completion(nil)
            }
            let json = JSON(parseJSON: string)
            let room = Room(withJSON: json)
            return completion(room)
        }
    }
    
    func joinRawRooms(rawRooms: [JSON]) {
        var rooms = [Room]()
        for rawRoom in rawRooms {
            rooms.append(Room(withJSON: rawRoom))
        }
        
        self.rooms.value = rooms
    }
    
}
