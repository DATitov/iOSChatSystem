//
//  SocketRequestContainer.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import SwiftyJSON

class SocketRequestContainer: NSObject {

    let dateCreated = Date()
    var completion: ((JSON?) -> ())?
    let uuid = UUID().uuidString
    
    func complete(params: JSON?) {
        guard let completion = completion else {
            return
        }
        completion(params)
    }
    
}
