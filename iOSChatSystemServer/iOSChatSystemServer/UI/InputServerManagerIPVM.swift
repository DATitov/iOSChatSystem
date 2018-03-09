//
//  InputServerManagerIPVM.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit

class InputServerManagerIPVM: UIView {

    func connect(urlString: String, comletion: @escaping ((Bool) -> ())) {
        ServerManagerInteractor.shared.connect(urlString: "http://" + urlString) { succeed in
            comletion(succeed)
        }
    }
    
}
