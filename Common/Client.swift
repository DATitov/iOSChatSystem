//
//  Client.swift
//  iOSChatSystemServerManager
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Client: NSObject {

    enum Keys: String {
        case Name = "name"
        case URLString = "url_string"
    }
    
    var name = ""
    var connectedServerURLString = ""
    var urlString = ""
    
    override init() {
        super.init()
    }
    
    init(withJSON json: JSON) {
        super.init()
        
        if let name = json[Keys.Name.rawValue].string {
            self.name = name
        }
        
        if let urlString = json[Keys.URLString.rawValue].string {
            self.urlString = urlString
        }
    }
    
}
