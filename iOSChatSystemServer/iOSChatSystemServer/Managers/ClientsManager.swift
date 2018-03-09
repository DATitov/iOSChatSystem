//
//  ClientsManager.swift
//  iOSChatSystemServer
//
//  Created by Dmitrii Titov on 04.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift

class ClientsManager: NSObject {
    
    static let shared: ClientsManager = {
        let instance = ClientsManager()
        return instance
    }()
    
    let clients = Variable<[Client]>([Client]())
    
    func addClient(client: Client) {
        let clientsWithThisURL = clients.value.filter({ $0.urlString == client.urlString })
        if clientsWithThisURL.count > 0 {
            for c in clientsWithThisURL {
                c.name = client.name
            }
        }else{
            clients.value.append(client)
        }
    }
    
}

