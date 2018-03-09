//
//  ClientsInteractor.swift
//  iOSChatSystemServerManager
//
//  Created by Dmitrii Titov on 04.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Cocoa

class ClientsInteractor: NSObject {
    
    static let shared: ClientsInteractor = {
        let instance = ClientsInteractor()
        return instance
    }()
    
    func connectServer(server: Server) {
        
    }
    
    func sendPing(serverURLString: String, completion: @escaping () -> (), failureCompletion: @escaping () -> ()) {
        let params = ["method" : ClientsMethod.Ping.rawValue]
        
        RemoteServerInteractor.shared.executeRequest(urlString: serverURLString,
                                                     params: params,
                                                     completion: { (data, response, error) in
                                                        if let error = error {
                                                            print(error.localizedDescription)
                                                            return failureCompletion()
                                                        }
                                                        completion()
        })
    }

}
