//
//  ViewController.swift
//  iOSChatSystemServerManager
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class ViewController: NSViewController {

    @IBOutlet var ipLabel: NSTextField!
    @IBOutlet var clientsTableView: NSTableView!
    @IBOutlet var serversTableView: NSTableView!

    let disposeBag = DisposeBag()
    
    let ipAddress = Variable<String>("")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initBindings()
    }
    
    func initBindings() {
        LocalServer.shared.serverURLString.asObservable()
            .bind(to: self.ipAddress)
            .disposed(by: self.disposeBag)
        
        ipAddress.asObservable()
            .map({ "Менеджер url: \($0)" })
            .bind(to: self.ipLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        ClientsManager.shared.clients.asObservable()
            .subscribe(onNext: { (clients) in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.clientsTableView.reloadData()
                }
            })
            .disposed(by: self.disposeBag)
        
        ServersManager.shared.servers.asObservable()
            .subscribe(onNext: { (servers) in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.serversTableView.reloadData()
                }
            })
            .disposed(by: self.disposeBag)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let text: String = ""
        let cellIdentifier: String = "Identitier"
        let item = value(forTV: tableView, row: row) ?? ""
        
        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = item
            return cell
        }else{
            return nil
        }
    }
    
    func value(forTV tv: NSTableView, row: Int) -> String? {
        if tv.isEqual(self.clientsTableView) {
            if row < ClientsManager.shared.clients.value.count {
                return ClientsManager.shared.clients.value[row].urlString
            }else{
                return nil
            }
        }else if tv.isEqual(self.serversTableView) {
            if row < ServersManager.shared.servers.value.count {
                return ServersManager.shared.servers.value[row].urlString
            }else{
                return nil
            }
        }
        return nil
    }
    
}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView.isEqual(self.clientsTableView) {
            return ClientsManager.shared.clients.value.count
        }else if tableView.isEqual(self.serversTableView) {
            return ServersManager.shared.servers.value.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableView.isEqual(self.clientsTableView) {
            if row < ClientsManager.shared.clients.value.count {
                return ClientsManager.shared.clients.value[row].urlString
            }else{
                return nil
            }
        }else if tableView.isEqual(self.serversTableView) {
            if row < ServersManager.shared.servers.value.count {
                return ServersManager.shared.servers.value[row].urlString
            }else{
                return nil
            }
        }
        return nil
    }
    
}

