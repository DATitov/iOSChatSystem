//
//  ChatSocketManager.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 11.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import DateToolsSwift
import SwiftyJSON

class ChatSocketManager: SocketManager {
    
    static let sharedCSM: ChatSocketManager = {
        let instance = ChatSocketManager()
        return instance
    }()
    
    override func write(urlString: String, params: [String : Any], completion: ((JSON?) -> ())?) {
        var mutableParams = params
        let container = SocketRequestContainer()
        container.completion = completion
        mutableParams["request_uuid"] = container.uuid
        print("request created: " + container.uuid)
        if completion != nil {
            requestContainers.append(container)
        }
        
        RemoteServerInteractor.shared.executeRequest(urlString: urlString,
                                                     params: ["method": ClientsMethod.ReceiveChatMessage.rawValue,
                                                              "params": mutableParams as [String: Any]
        ]) { (data, response, error) in
            
        }
    }

}
