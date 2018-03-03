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

class LocalServer: NSObject {
    
    static let shared: LocalServer = {
        let instance = LocalServer()
        return instance
    }()
    
    private let server = GCDWebServer()
    
    override init() {
        super.init()
        
        initHandlers()
        
        server.start()
    }
    
    func initHandlers() {
        server.addDefaultHandler(forMethod: "GET", request: GCDWebServerDataRequest.self) { (request, completion) in
            guard let dataRequest = request as? GCDWebServerDataRequest else {
                return completion(GCDWebServerResponse(statusCode: 404))
            }
            let params = self.params(fromQuery: dataRequest.query)
            let method = params["method"] as? String ?? ""
            let json = JSON(data: dataRequest.data)
            LocalServerInteractor.shared.execute(method: method, params: json, completion: { text in
                let response = GCDWebServerDataResponse(text: text)
                completion(response)
            })
        }
        server.addDefaultHandler(forMethod: "POST", request: GCDWebServerDataRequest.self) { (request, completion) in
            guard let dataRequest = request as? GCDWebServerDataRequest else {
                return completion(GCDWebServerResponse(statusCode: 404))
            }
            let params = self.params(fromQuery: dataRequest.query)
            let method = params["method"] as? String ?? ""
            let json = JSON(data: dataRequest.data)
            LocalServerInteractor.shared.execute(method: method, params: json, completion: { text in
                let response = GCDWebServerDataResponse(text: text)
                completion(response)
            })
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
    
}

extension LocalServer: GCDWebServerDelegate {
    
    func webServerDidStart(_ server: GCDWebServer) {
        
    }
    
    func webServerDidConnect(_ server: GCDWebServer) {
        
    }
    
}
