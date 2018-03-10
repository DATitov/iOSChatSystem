//
//  InputServerManagerIPVM.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit

class InputServerManagerIPVM: UIView {

    func connect(urlString: String, comletion: @escaping ((Bool) -> ())) {
        let string = urlString.starts(with: "http://")
            ? urlString
            : "http://" + urlString
        ServerManagerInteractor.shared.connect(urlString: string) { succeed in
            comletion(succeed)
            if succeed {
                ServerManagerInteractor.shared.requestServerURL(comletion: { (urlString) in
                    UsersManager.shared.getUser()
                    ServerInteractor.shared.loadRooms()
                    UsersManager.shared.loadUsers()
                })
            }
        }
    }
    
}
