//
//  UserDefaultsInteractor.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 04.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit

class UserDefaultsInteractor: NSObject {

    private let serverManagerURLStringKey = "server_manager_url_string"
    
    func getServerManagerURLString() -> String {
        return UserDefaults.standard.string(forKey: serverManagerURLStringKey) ?? ""
    }
    
    func setServerManagerURLString(serverManagerURLString: String) {
        UserDefaults.standard.set(serverManagerURLString, forKey: serverManagerURLStringKey)
        UserDefaults.standard.synchronize()
    }
    
}
