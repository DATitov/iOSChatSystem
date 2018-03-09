//
//  ServerInfoManager.swift
//  iOSChatSystemServer
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift

class ServerInfoManager: NSObject {
    
    static let shared: ServerInfoManager = {
        let instance = ServerInfoManager()
        return instance
    }()

    let serverName = Variable<String>(UserDefaultsInteractor().getServerName())
    
    func updateServerName(name: String) {
        UserDefaultsInteractor().setServerName(serverName: name)
        serverName.value = name
    }
    
}
