//
//  MainTVC.swift
//  iOSChatSystemServer
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DTAlertViewContainer
import Realm
import RealmSwift

class MainTVC: UITableViewController {

    let disposeBag = DisposeBag()
    
    @IBOutlet var serverNameLabel: UILabel!
    @IBOutlet var serverURLLabel: UILabel!
    @IBOutlet var serverManagerURLLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBindings()
        
        navigationController?.title = "Сервер"
    }
    
    func initBindings() {
        LocalServer.shared.serverURLString.asObservable()
            .bind(to: self.serverURLLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        ServerInfoManager.shared.serverName.asObservable()
            .bind(to: self.serverNameLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        ServerManagerInteractor.shared.serverManagerURLString.asObservable()
            .bind(to: self.serverManagerURLLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let container = DTAlertViewContainerController()
            let alertView = InputServerNameView(ipAddress: serverNameLabel.text ?? "")
            
            container.presentOverVC(self, alert: alertView, appearenceAnimation: .fromTop, completion: nil)
        }else if indexPath.section == 0 && indexPath.row == 2 {
            let container = DTAlertViewContainerController()
            let alertView = InputServerManagerIPAlertView(ipAddress: ServerManagerInteractor.shared.serverManagerURLString.value)
            
            container.presentOverVC(self, alert: alertView, appearenceAnimation: .fromTop, completion: nil)
        }else if indexPath.section == 0 && indexPath.row == 3 {
            clearDatabase()
        }
    }
    
    @IBAction func clearAllAction() {
        clearDatabase()
    }
    
    func clearDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
