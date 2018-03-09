//
//  UserDefaultsInteractor.swift
//  iOSChatSystemServer
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit

class UserDefaultsInteractor: NSObject {
    
    private let serverManagerURLStringKey = "server_manager_url_string"
    private let serverNameKey = "server_name"
    
    func getServerManagerURLString() -> String {
        return UserDefaults.standard.string(forKey: serverManagerURLStringKey) ?? ""
    }
    
    func getServerName() -> String {
        return UserDefaults.standard.string(forKey: serverNameKey) ?? ""
    }
    
    func setServerManagerURLString(serverManagerURLString: String) {
        UserDefaults.standard.set(serverManagerURLString, forKey: serverManagerURLStringKey)
        UserDefaults.standard.synchronize()
    }
    
    func setServerName(serverName: String) {
        UserDefaults.standard.set(serverName, forKey: serverNameKey)
        UserDefaults.standard.synchronize()
    }

}
