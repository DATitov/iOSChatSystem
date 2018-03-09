//
//  SocketRequestContainer.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit

class SocketRequestContainer: NSObject {

    let dateCreated = Date()
    var completion: (() -> ())?
    let uuid = UUID().uuidString
    
    func complete() {
        guard let completion = completion else {
            return
        }
        completion()
    }
    
}
