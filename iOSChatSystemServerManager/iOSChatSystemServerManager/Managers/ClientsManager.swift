//
//  ClientsManager.swift
//  iOSChatSystemServerManager
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Cocoa
import RxSwift

class ClientsManager: NSObject {
    
    static let shared: ClientsManager = {
        let instance = ClientsManager()
        return instance
    }()
    
    let clients = Variable<[Client]>([Client]())
    
    override init() {
        super.init()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            for serverURLString in self.clients.value.map({ $0.urlString }) {
                ClientsInteractor.shared.sendPing(serverURLString: serverURLString,
                                                  completion: {
                                                    
                },
                                                  failureCompletion: {
                                                    self.removeClient(withURLString: serverURLString)
                })
            }
        }
    }
    
    func addClient(client: Client) {
        let clientsWithThisURL = clients.value.filter({ $0.urlString == client.urlString })
        if clientsWithThisURL.count > 0 {
            for c in clientsWithThisURL {
                c.name = client.name
            }
            clients.value = clients.value
        }else{
            clients.value.append(client)
        }
    }
    
    func removeClient(withURLString urlString: String) {
        var indexes: Int?
        for (index, clientURLString) in clients.value.map({ $0.urlString }).enumerated() {
            if clientURLString == urlString {
                indexes = index
                break
            }
        }
        if let index = indexes {
            clients.value.remove(at: index)
        }
    }

}
