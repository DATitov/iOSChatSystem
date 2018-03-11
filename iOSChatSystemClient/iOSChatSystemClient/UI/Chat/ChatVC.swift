
//
//  ChatVC.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 10.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import QMChatViewController

class ChatVC: QMChatViewController {
    
    let disposeBag = DisposeBag()
    
    var vm: ChatScreenVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderID = 2
        senderDisplayName = UsersManager.shared.getCurrentUser().name
        
        view.backgroundColor = UIColor.lightGray
    }
    
    func inject(viewModel: ChatScreenVM) {
        vm = viewModel
        
        vm?.newMessages.asObservable()
            .subscribe(onNext: { (newMessages) in
                DispatchQueue.main.async {
                    print("messages count: \(newMessages.count)")
                    self.chatDataSource.add(newMessages)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    override func didPressSend(_ button: UIButton!,
                               withMessageText text: String!,
                               senderId: UInt,
                               senderDisplayName: String!,
                               date: Date!) {
        
        if let message = vm?.sendMessage(text: text) {
            chatDataSource.add(ChatManager.qbMessage(fromMessage: message))
        }
    }
    
    override func viewClass(forItem item: QBChatMessage!) -> AnyClass! {
        return item.senderID == 2
            ? QMChatOutgoingCell.self
            : QMChatIncomingCell.self
    }
    
    override func collectionView(_ collectionView: QMChatCollectionView!, minWidthAt indexPath: IndexPath!) -> CGFloat {
        return  60
    }
    
    override func collectionView(_ collectionView: QMChatCollectionView!, dynamicSizeAt indexPath: IndexPath!, maxWidth: CGFloat) -> CGSize {
        let label = UILabel()
        label.text = chatDataSource.message(for: indexPath).text ?? ""
        return label.sizeThatFits(CGSize(width: maxWidth, height: 10000))
    }
    
    override func attributedString(forItem messageItem: QBChatMessage!) -> NSAttributedString! {
        return NSAttributedString(string: messageItem.text ?? "")
    }

    override func topLabelAttributedString(forItem messageItem: QBChatMessage!) -> NSAttributedString! {
        return NSAttributedString(string: messageItem.text ?? "")
    }
    
    override func bottomLabelAttributedString(forItem messageItem: QBChatMessage!) -> NSAttributedString! {
        return NSAttributedString(string: messageItem.text ?? "")
    }
    
}
