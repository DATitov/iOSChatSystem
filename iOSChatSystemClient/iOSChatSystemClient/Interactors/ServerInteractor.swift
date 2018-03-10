//
//  ServerInteractor.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift

class ServerInteractor: NSObject {
    
    static let shared: ServerInteractor = {
        let instance = ServerInteractor()
        return instance
    }()

    let serverURLString = Variable<String>("")
    
    fileprivate var afeterServerConnectedQuery = [() -> ()]()

    func loadRooms() {
        RemoteServerInteractor.shared.executeRequest(urlString: serverURLString.value,
                                                     params: ["method": "\"\(ServerMethod.ReceiveMessage.rawValue)\"",
                                                              "params":
                                                                [
                                                                    "method": "\"\(ServerMethod.Socket.LoadRooms.rawValue)\""
                                                                ] as [String: Any]
        ]) { (data, response, error) in
                                                                    
        }
    }
    
}
