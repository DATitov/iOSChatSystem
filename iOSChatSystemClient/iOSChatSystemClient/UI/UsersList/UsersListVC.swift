//
//  UsersListVC.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsersListVC: UIViewController {
    
    let users = Variable<[User]>([User]())

    let vm = UsersListVM()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBindings()
    }
    
    func initBindings() {
        
    }


}
