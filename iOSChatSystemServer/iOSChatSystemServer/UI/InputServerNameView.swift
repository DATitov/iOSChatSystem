//
//  InputServerNameView.swift
//  iOSChatSystemServer
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import DTAlertViewContainer

class InputServerNameView: UIView, DTAlertViewProtocol {
    
    let titleLabel = UILabel()
    let textField = UITextField()
    let cancelButton = UIButton()
    let connectButton = UIButton()
    let activityView = UIActivityIndicatorView()
    
    var delegate: DTAlertViewContainerProtocol!
    
    var requiredHeight: CGFloat = 240
    
    var frameToFocus: CGRect = .zero
    
    var needToFocus: Bool = false
    
    private var ipAddress = ""
    
    init(ipAddress: String) {
        super.init(frame: .zero)
        
        self.ipAddress = ipAddress
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        for view in [titleLabel, textField, cancelButton, connectButton, activityView] {
            addSubview(view)
        }
        
        activityView.activityIndicatorViewStyle = .gray
        
        for button in [cancelButton, connectButton] {
            button.setTitleColor(UIColor.blue, for: .normal)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.text = "Введите имя сервера"
        
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.placeholder = "Имя сервера"
        textField.text = ipAddress
        textField.textAlignment = .right
        textField.delegate = self
        
        cancelButton.setTitle("Отмена", for: .normal)
        connectButton.setTitle("Поменять имя", for: .normal)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
        
        backgroundColor = UIColor.gray
        layer.cornerRadius = 5
    }
    
    func dissmissIfAble() {
        guard let delegate = delegate else {
            return
        }
        delegate.dismiss()
    }
    
    @objc func cancelButtonPressed() {
        guard let delegate = delegate else {
            return
        }
        delegate.dismiss()
    }
    
    @objc func connectButtonPressed() {
        guard let text = textField.text else {
            return
        }
        
        ServerInfoManager.shared.updateServerName(name: text)
        delegate.dismiss()
    }
    
    func backgroundPressed() {
        dissmissIfAble()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewsHeight: CGFloat = 40
        let verticalOffset: CGFloat = 30
        let horOffset: CGFloat = 15
        
        titleLabel.frame = CGRect(x: horOffset, y: verticalOffset, width: frame.size.width - 2.0 * horOffset, height: viewsHeight)
        textField.frame = CGRect(x: horOffset, y: 2.0 * verticalOffset + viewsHeight, width: frame.size.width - 2.0 * horOffset, height: viewsHeight)
        
        let bYCoord = 3.0 * verticalOffset + 2.0 * viewsHeight
        let butWidth = (frame.size.width - 4.0 * horOffset) / 2.0
        cancelButton.frame = CGRect(x: horOffset, y: bYCoord, width: butWidth, height: viewsHeight)
        connectButton.frame = CGRect(x: 2.0 * horOffset + butWidth, y: bYCoord, width: butWidth, height: viewsHeight)
        
        activityView.frame = self.bounds
    }
    
}

extension InputServerNameView: UITextFieldDelegate {
    
}
