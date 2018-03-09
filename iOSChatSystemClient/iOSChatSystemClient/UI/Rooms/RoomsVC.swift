//
//  RoomsVC.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RoomsVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!

    let rooms = Variable<[Room]>(RoomsManager.shared.rooms.value)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Диалоги"
        
        initBindings()
    }
    
    func initBindings() {
        RoomsManager.shared.rooms.asObservable()
            .bind(to: self.rooms)
            .disposed(by: self.disposeBag)
        
        rooms.asObservable()
            .subscribe(onNext: { (rooms) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: self.disposeBag)
    }

}

extension RoomsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let s = UIStoryboard(name: "Main", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "UsersListVC") as! UsersListVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension RoomsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0
            ? 1
            : rooms.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "Add_room_Identifier")!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTVCellIdentifier") as! RoomTVCell
            
            if rooms.value.count > indexPath.row {
                let room = rooms.value[indexPath.row]
                cell.nameLabel.text = room.name
                cell.messagesIndicatorLabel.text = "\(room.unreadMessagesCount)"
            }
            
            return cell
        }
    }
    
}