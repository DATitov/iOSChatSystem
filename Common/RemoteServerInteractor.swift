//
//  RemoteServerInteractor.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Foundation
import Alamofire

class RemoteServerInteractor: NSObject {
    
    static let shared: RemoteServerInteractor = {
        let instance = RemoteServerInteractor()
        return instance
    }()

    func executeRequest(urlString: String, completion: @escaping (() -> ())) {
        Alamofire.request(urlString).response { (response) in
            completion()
        }
    }
    
}
