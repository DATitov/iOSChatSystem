//
//  ServerManagerInteractor.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift

class ServerManagerInteractor: NSObject {
    
    static let shared: ServerManagerInteractor = {
        let instance = ServerManagerInteractor()
        return instance
    }()
    
    let serverManagerURLString = Variable<String>(UserDefaultsInteractor().getServerManagerURLString())
    let serverManagerConnected = Variable<Bool>(false)
    
    var timer: Timer!
    
    override init() {
        super.init()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            if !self.serverManagerConnected.value {
                self.connect(urlString: self.serverManagerURLString.value, comletion: { _ in
                    self.requestServerURL(comletion: { _ in
                        
                    })
                })
            }
        })
    }
    
    func connect(urlString: String, comletion: @escaping ((Bool) -> ())) {
        let params = ["method": ServerManagerMethod.ConnectClient.rawValue,
                      "client": [
                        "name" : "",
                        "url_string" : LocalServer.shared.serverURLString.value
            ]] as [String : Any]
        RemoteServerInteractor.shared.executeRequest(urlString: urlString, params: params) { (data, response, error) in
            let success = error == nil && (data != nil || response != nil)
            if success {
                UserDefaultsInteractor().setServerManagerURLString(serverManagerURLString: urlString)
                self.serverManagerConnected.value = true
            }
            self.serverManagerURLString.value = urlString
            comletion(success)
        }
    }
    
    func requestServerURL(comletion: @escaping ((String) -> ())) {
        let params = ["method": ServerManagerMethod.ConnectToServer.rawValue,
                      "client": [
                        "name" : "",
                        "url_string" : LocalServer.shared.serverURLString.value
            ]] as [String : Any]
        RemoteServerInteractor.shared.executeRequest(urlString: serverManagerURLString.value, params: params) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            let text = { () -> String in
                guard let data = data, let text = String(data: data, encoding: .utf8) else {
                    return ""
                }
                return text
            }()
            
            self.storeServerURLString(text: text)
            
            comletion(text)
        }
    }
    
    func storeServerURLString(text: String) {
        let json = JSON(parseJSON: text)
        let serverURLString = json["server_url"].stringValue
        if serverURLString.contains("http") {
            ServerInteractor.shared.serverURLString.value = serverURLString
        }
    }

}
