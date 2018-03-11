//
//  ServerManagerInteractor.swift
//  iOSChatSystemServer
//
//  Created by Dmitrii Titov on 04.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

class ServerManagerInteractor: NSObject {
    
    static let shared: ServerManagerInteractor = {
        let instance = ServerManagerInteractor()
        return instance
    }()
    
    let serverConnected = Variable<Bool>(false)
    var serverManagerURLString = Variable<String>(UserDefaultsInteractor().getServerManagerURLString())
    var recconectTimer: Timer!
    var pingTimer: Timer!
    
    override init() {
        super.init()
        
        self.recconectTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.recconectIfNeeded), userInfo: nil, repeats: true)
        self.pingTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.sendPing), userInfo: nil, repeats: true)
        
    }
    
    @objc func recconectIfNeeded() {
        if !self.serverConnected.value {
            self.connect(urlString: self.serverManagerURLString.value, comletion: {_ in })
        }
        
        RemoteServerInteractor.shared.executeRequest(urlString: self.serverManagerURLString.value,
                                                     params: ["method": ServerManagerMethod.GetAllServers.rawValue]) { (data, response, error) in
                                                        guard let data = data,
                                                        let jsonString = String(data: data, encoding: .utf8) else {
                                                            return
                                                        }
                                                        
                                                        let json = JSON(parseJSON: jsonString)
                                                        let servers = json["servers"].arrayValue
                                                            .map({ Server(withJSON: $0).urlString })
                                                            .filter({ $0 != LocalServer.shared.serverURLString.value })
                                                        
                                                        self.shareData(serversURLS: servers)
        }
    }
    
    func shareData(serversURLS: [String]) {
        let jsonArray: (([String]) -> (String)) = { array in
            var jsonString = "["
            for (index, str) in array.enumerated() {
                jsonString.append(str)
                jsonString.append(index == array.count - 1 ? "]" : ",")
            }
            if jsonString == "[" {
                jsonString = "[]"
            }
            return jsonString
        }
        let users = UsersManager().users().map({ (user) -> String in
            let string = user.toJOSNStr()
            return string
        })
        
        let rooms = RoomsManager().rooms().map({ (room) -> String in
            let string = room.toJOSNStr()
            return string
        })
        
        let usersJSONString = jsonArray(users)
        let roomsJSONString = jsonArray(rooms)
        
        for serverURLString in serversURLS {
            RemoteServerInteractor.shared.executeRequest(urlString: serverURLString,
                                                         params: ["method": ServerMethod.ReceiveData.rawValue,
                                                                  "users": users,
                                                                  "rooms": rooms],
                                                         completion: { (data, response, error) in
                                                            guard let data = data,
                                                                let jsonString = String(data: data, encoding: .utf8) else {
                                                                    return
                                                            }
                                                            print("")
            })
        }
    }
    
    @objc func sendPing() {
        if serverConnected.value {
            RemoteServerInteractor.shared.executeRequest(urlString: serverManagerURLString.value,
                                                         params: ["method": ServerManagerMethod.Ping.rawValue]) { (data, response, error) in
                                                            if let error = error {
                                                                self.serverConnected.value = false
                                                            }
            }
        }
    }
    
    func connect(urlString: String, comletion: @escaping ((Bool) -> ())) {
        let params = ["method": ServerManagerMethod.ConnectServer.rawValue,
                      "server": [
                        "name" : ServerInfoManager.shared.serverName.value,
                        "url_string" : LocalServer.shared.serverURLString.value
            ]] as [String : Any]
        RemoteServerInteractor.shared.executeRequest(urlString: urlString, params: params) { (data, response, error) in
            let success = error == nil && (data != nil || response != nil)
            if success {
                UserDefaultsInteractor().setServerManagerURLString(serverManagerURLString: urlString)
                ServerManagerInteractor.shared.serverManagerURLString.value = urlString
                self.serverConnected.value = true
            }
            comletion(success)
        }
    }

}
