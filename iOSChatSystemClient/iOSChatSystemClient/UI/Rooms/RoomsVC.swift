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
    
    let refreshControll = UIRefreshControl()

    let rooms = Variable<[Room]>(RoomsManager.shared.rooms.value)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Диалоги"
        
        initBindings()
        
        refreshControll.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControll)
        
        RoomsManager.shared.updateRooms()
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
    
    @objc func refresh() {
        RoomsManager.shared.updateRooms()
        refreshControll.endRefreshing()
    }

}

extension RoomsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let s = UIStoryboard(name: "Main", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "UsersListVC") as! UsersListVC
            vc.userSelectedAction = { user in
                RoomsManager.shared.createRoom(withUSer: user,
                                               completion: { (room) in
                                                print("")
                })
            }
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
                let name = { () -> String in
                    let userID = { () -> String in
                        if room.user1ID == LocalServer.shared.serverURLString.value {
                            return room.user2ID
                        }
                        return room.user1ID
                    }()
                    guard let user = UsersManager.shared.user(forID: userID) else {
                        return userID
                    }
                    return user.name.count > 0
                        ? user.name
                        : userID
                }()
                cell.nameLabel.text = name
                cell.messagesIndicatorLabel.text = room.unreadMessagesCount > 0
                    ? "\(room.unreadMessagesCount)"
                    : ""
            }
            
            return cell
        }
    }
    
}
