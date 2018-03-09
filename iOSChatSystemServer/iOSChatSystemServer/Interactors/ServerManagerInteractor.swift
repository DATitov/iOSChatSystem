//
//  ServerManagerInteractor.swift
//  iOSChatSystemServer
//
//  Created by Dmitrii Titov on 04.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift

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
//        Timer(timeInterval: 5, target: self, selector: #selector(self.recconectIfNeeded), userInfo: nil, repeats: true)
        self.pingTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.sendPing), userInfo: nil, repeats: true)
        //Timer(timeInterval: 5, target: self, selector: #selector(self.sendPing), userInfo: nil, repeats: true)
        
    }
    
    @objc func recconectIfNeeded() {
        if !self.serverConnected.value {
            self.connect(urlString: self.serverManagerURLString.value, comletion: {_ in })
        }
    }
    
    @objc func sendPing() {
        RemoteServerInteractor.shared.executeRequest(urlString: serverManagerURLString.value,
                                                     params: ["method": ServerManagerMethod.Ping.rawValue]) { (data, response, error) in
                                                        if let error = error {
                                                            self.serverConnected.value = false
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
