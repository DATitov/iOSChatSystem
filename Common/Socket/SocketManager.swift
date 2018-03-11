//
//  SocketManager.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import DateToolsSwift
import SwiftyJSON

class SocketManager: NSObject {
    
    static let shared: SocketManager = {
        let instance = SocketManager()
        return instance
    }()
    
    var timer: Timer!
    
    var requestContainers = [SocketRequestContainer]()
    
    override init() {
        super.init()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerIteraction), userInfo: nil, repeats: true)
    }
    
    @objc func timerIteraction() {
        var indexes = [Int]()
        
        let date = Date()
        for (index, container) in self.requestContainers.enumerated() {
            if date.seconds(from: date) > 6 {
                indexes.append(index)
            }
        }
        
        self.removeRequestContainers(atIndexes: indexes)
    }

    func write(urlString: String, params: [String: Any], completion: ((JSON?) -> ())?) {
        var mutableParams = params
        let container = SocketRequestContainer()
        container.completion = completion
        requestContainers.append(container)
        mutableParams["request_uuid"] = container.uuid
        print("request created: " + container.uuid)
        
        RemoteServerInteractor.shared.executeRequest(urlString: urlString,
                                                     params: ["method": ServerMethod.ReceiveMessage.rawValue,
                                                        "params": mutableParams as [String: Any]
        ]) { (data, response, error) in
            
        }
    }
    
    func removeRequestContainers(atIndexes indexes: [Int]) {
        for index in indexes {
            requestContainers[index].completion?(nil)
        }
        if indexes.count > 0 {
            requestContainers.remove(at: indexes.first!)
        }
    }
    
    func complete(withRequestUUID requestUUID: String, params: JSON) {
        guard let action = requestContainers.filter({ $0.uuid == requestUUID }).first else {
            return
        }
        requestContainers.remove(at: requestContainers.index(of: action)!)
        
        action.complete(params: params)
    }
    
}
