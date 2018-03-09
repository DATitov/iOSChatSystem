//
//  SettingsTVC.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DTAlertViewContainer

class SettingsTVC: UITableViewController {

    @IBOutlet var serverManagerIPAdderssLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBindings()
    }

    func initBindings() {
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            return serverManagerIPCellSelectd()
        default:
            return
        }
    }
    
    func serverManagerIPCellSelectd() {
        let container = DTAlertViewContainerController()
        let alertView = InputServerManagerIPAlertView(ipAddress: serverManagerIPAdderssLabel.text ?? "")
        
        container.presentOverVC(self, alert: alertView, appearenceAnimation: .fromTop, completion: nil)
    }
    
}
