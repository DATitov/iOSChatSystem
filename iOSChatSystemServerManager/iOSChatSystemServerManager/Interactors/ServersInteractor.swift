//
//  ServersInteractor.swift
//  iOSChatSystemServerManager
//
//  Created by Dmitrii Titov on 04.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Cocoa

class ServersInteractor: NSObject {
    
    static let shared: ServersInteractor = {
        let instance = ServersInteractor()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    func setupTimers() {
        
    }
    
    func connectServer(server: Server) {
        
    }
    
    func sendPing(serverURLString: String, completion: @escaping () -> (), failureCompletion: @escaping () -> ()) {
        let params = ["method" : ServerMethod.Ping.rawValue]
        
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
