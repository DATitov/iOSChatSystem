//
//  ServersManager.swift
//  iOSChatSystemServerManager
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Cocoa
import RxSwift

class ServersManager: NSObject {
    
    static let shared: ServersManager = {
        let instance = ServersManager()
        return instance
    }()
    
    let servers = Variable<[Server]>([Server]())
    
    override init() {
        super.init()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            for serverURLString in self.servers.value.map({ $0.urlString }) {
                ServersInteractor.shared.sendPing(serverURLString: serverURLString,
                                                  completion: {
                                                    
                },
                                                  failureCompletion: {
                                                    self.removeServer(withURLString: serverURLString)
                })
            }
        }
    }
    
    func connectClient(client: Client) -> String? {
        if servers.value.count < 1 {
            return nil
        }
        
        var minIndex = 0
        var min = Int.max
        for (index, server) in servers.value.enumerated() {
            if server.connectedClients < min {
                min = server.connectedClients
                minIndex = index
            }
        }
        return servers.value[minIndex].urlString
    }
    
    func addServer(server: Server) {
        let serversWithThisURL = servers.value.filter({ $0.urlString == server.urlString })
        if serversWithThisURL.count > 0 {
            for c in serversWithThisURL {
                c.name = server.name
            }
            servers.value = servers.value
        }else{
            servers.value.append(server)
        }
    }
    
    func removeServer(withURLString urlString: String) {
        var indexes: Int?
        for (index, serverURLString) in servers.value.map({ $0.urlString }).enumerated() {
            if serverURLString == urlString {
                indexes = index
                break
            }
        }
        if let index = indexes {
            servers.value.remove(at: index)
        }
    }

}
