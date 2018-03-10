//
//  LocalServer.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Foundation
import GCDWebServer
import SwiftyJSON
import RxSwift

class LocalServer: NSObject {
    
    static let shared: LocalServer = {
        let instance = LocalServer()
        return instance
    }()
    
    fileprivate var afeterServerLaunchedQuery = [() -> ()]()
    
    let serverURLString = Variable<String>("")
    
    private let server = GCDWebServer()
    
    var serverStarted = false
    
    override init() {
        super.init()
        
        server.delegate = self
        
        initHandlers()
        
        start()
    }
    
    func start() {
        var port = 8000
        var b = false
        while !b && port < 8500 {
            b = server.start(withPort: UInt(port), bonjourName: "Bonj")
            port += 1
        }
    }
    
    func initHandlers() {
        server.addHandler(match: { (requestMethod, requestURL, requestHeaders, urlPath, urlQuery) -> GCDWebServerRequest? in
            return GCDWebServerDataRequest(method: requestMethod, url: requestURL, headers: requestHeaders, path: urlPath, query: urlQuery)
        }) { (request, completion) in
            guard let dataRequest = request as? GCDWebServerDataRequest else {
                return completion(GCDWebServerErrorResponse(statusCode: 404))
            }
            let sender = request.headers[RemoteServerInteractor.shared.senderURLHeaderKey]
            let params = self.params(data: dataRequest.data) ?? [String: Any]()
            let method = params["method"] as? String ?? ""
            let json = JSON(data: dataRequest.data)
            LocalServerInteractor.shared.execute(method: method, params: json, completion: { text in
                let response = GCDWebServerDataResponse(text: text)
                completion(response)
            })
        }
    }
    
    func params(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch{
            return nil
        }
    }
    
    func params(fromQuery query: [AnyHashable: Any]?) -> [String: Any] {
        guard let query = query else {
            return [String: String]()
        }
        
        let filtredQuery = query.filter({ (key, value) -> Bool in
            guard let stringKey = key as? String else {
                return false
            }
            return true
        })
        
        var params = [String: Any]()
        for pair in filtredQuery {
            let strKey = pair.key as! String
            params[strKey] = pair.value
        }
        
        return params
    }
    
    func executeOnServerLaunched(action: @escaping () -> ()) {
        if serverStarted {
            action()
        }else{
            afeterServerLaunchedQuery.append(action)
        }
    }
    
}

extension LocalServer: GCDWebServerDelegate {
    
    func webServerDidStart(_ server: GCDWebServer) {
        serverStarted = true
        if let url = server.serverURL {
            serverURLString.value = url.absoluteString
        }
        for action in afeterServerLaunchedQuery {
            action()
        }
    }
    
    func webServerDidConnect(_ server: GCDWebServer) {
        
    }
    
    func webServerDidDisconnect(_ server: GCDWebServer) {
        
    }
    
    
}
