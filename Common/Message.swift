//
//  Message.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SwiftyJSON

class Message: Object {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var text = ""
    @objc dynamic var roomID = ""
    @objc dynamic var senderID = ""
    @objc dynamic var date = Date()
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    init(withJSON json: JSON) {
        super.init()
        
        id = json["id"].stringValue
        text = json["text"].stringValue
        roomID = json["roomID"].stringValue
        senderID = json["senderID"].stringValue
        date = date(fromString: json["date"].stringValue)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func dateString() -> String {
        return DateFormatter(withFormat: "EEE, dd MMM yyyy hh:mm:ss +zzzz", locale: "ru_RU").string(from: Date())
    }
    
    func date(fromString string: String) -> Date {
        return DateFormatter(withFormat: "EEE, dd MMM yyyy hh:mm:ss +zzzz", locale: "ru_RU").date(from: string)!
    }
    
    func toJSONStr() -> String {
        var str = "{"
        str.append("\"id\":\"\(id)\", ")
        str.append("\"text\":\"\(text)\", ")
        str.append("\"roomID\":\"\(roomID)\", ")
        str.append("\"senderID\":\"\(senderID)\", ")
        str.append("\"date\":\"\(dateString())\"}")
        return str
    }
    
}
