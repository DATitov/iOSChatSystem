//
//  SocketManager.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import DateToolsSwift

class SocketManager: NSObject {
    
    static let shared: SocketManager = {
        let instance = SocketManager()
        return instance
    }()
    
    var requestContainers = [SocketRequestContainer]()
    
    override init() {
        super.init()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {_ in
            var indexes = [Int]()
            
            let date = Date()
            for (index, container) in self.requestContainers.enumerated() {
                if date.seconds(from: date) > 6 {
                    indexes.append(index)
                }
            }
            
            self.removeRequestContainers(atIndexes: indexes)
        }
    }

    func write(params: [String: Any], completion: (() -> ())?) {
        let requestUUID = UUID().uuidString
        var mutableParams = params
        let container = SocketRequestContainer()
        container.completion = completion
        mutableParams["request_uuid"] = container.uuid
            
        
            RemoteServerInteractor.shared.executeRequest(urlString: ServerInteractor.shared.serverURLString.value,
                                                         params: ["method": "\"\(ServerMethod.ReceiveMessage.rawValue)\"",
                                                            "params": mutableParams as [String: Any]
            ]) { (data, response, error) in
                
            }
    }
    
    func removeRequestContainers(atIndexes indexes: [Int]) {
        for index in indexes {
            requestContainers[index].completion?()
        }
        if indexes.count > 0 {
            requestContainers.remove(at: indexes.first!)
        }
    }
    
}
