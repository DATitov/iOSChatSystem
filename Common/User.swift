//
//  User.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SwiftyJSON
import ObjectMapper

class User: Object, Mappable {
    
    let idKey = "id"
    let nameKey = "name"
    
    required init?(map: Map) {
        super.init()
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    
    init(json: JSON) {
        super.init()
        
        self.id = json[idKey].stringValue
        self.name = json[nameKey].stringValue
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
    func toJOSNStr() -> String {
        var jsonStr = "{"
        jsonStr.append("\"\(idKey)\":\"\(self.id)\",")
        jsonStr.append("\"\(nameKey)\":\"\(self.name)\"")
        return jsonStr + "}"
    }
    
}
