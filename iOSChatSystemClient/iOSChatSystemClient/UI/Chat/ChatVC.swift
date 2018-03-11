
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
import DateToolsSwift

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
        
        finishSendingMessage()
        if let message = vm?.sendMessage(text: text) {
            chatDataSource.add(ChatManager.qbMessage(fromMessage: message))
        }
    }
    
    override func viewClass(forItem item: QBChatMessage!) -> AnyClass! {
        if (item.text?.contains("Today"))! {
            return QMChatNotificationCell.self
        }
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
        let size = label.sizeThatFits(CGSize(width: maxWidth, height: 10000))
        
        return CGSize(width: size.width, height: size.height * 1.4)
    }
    
    override func attributedString(forItem messageItem: QBChatMessage!) -> NSAttributedString! {
        return NSAttributedString(string: messageItem.text ?? "")
    }

    override func topLabelAttributedString(forItem messageItem: QBChatMessage!) -> NSAttributedString! {
        
        switch messageItem.senderID {
        case 0:
            return NSAttributedString(string: "" )
        case 1:
            return NSAttributedString(string: vm?.chatManager.otherUserName ?? "")
        case 2:
            return NSAttributedString(string: "Я")
        default:
            return NSAttributedString(string: "" )
        }
    }
    
    override func bottomLabelAttributedString(forItem messageItem: QBChatMessage!) -> NSAttributedString! {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd hh:mm:ss +zzzz"
        guard let date = messageItem.dateSent ?? messageItem.createdAt else {
            return NSAttributedString(string: "")
        }
        return NSAttributedString(string: dateFormat.string(from: date))
    }
    
}
