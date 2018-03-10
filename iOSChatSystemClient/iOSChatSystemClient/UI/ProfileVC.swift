//
//  ProfileVC.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var toolBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.inputAccessoryView = toolBar
        textField.text = UsersManager.shared.getCurrentUser().name
    }
    
    @IBAction func updateProfile() {
        textField.resignFirstResponder()
        update()
    }
    
    @IBAction func updateToolbarActoon() {
        textField.resignFirstResponder()
        update()
    }

    
    @IBAction func cancelToolbarActoon() {
        textField.resignFirstResponder()
    }

    func update() {
        let user = User()
        user.id = LocalServer.shared.serverURLString.value
        user.name = textField.text ?? ""
        UsersManager.shared.updateUser(user: user)
    }

}
