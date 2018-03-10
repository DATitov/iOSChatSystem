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
    
    let disposeBag = DisposeBag()

    @IBOutlet var serverManagerIPAdderssLabel: UILabel!
    @IBOutlet var serverURLLabel: UILabel!
    @IBOutlet var clientURLLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initBindings()
    }

    func initBindings() {
        ServerManagerInteractor.shared.serverManagerURLString.asObservable()
            .bind(to: self.serverManagerIPAdderssLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        ServerInteractor.shared.serverURLString.asObservable()
            .bind(to: self.serverURLLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        LocalServer.shared.serverURLString.asObservable()
            .bind(to: self.clientURLLabel.rx.text)
            .disposed(by: self.disposeBag)
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
