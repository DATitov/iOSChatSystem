//
//  InputServerManagerIPAlertView.swift
//  iOSChatSystemClient
//
//  Created by Dmitrii Titov on 03.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import UIKit
import DTAlertViewContainer

class InputServerManagerIPAlertView: UIView, DTAlertViewProtocol {
    
    let vm = InputServerManagerIPVM()
    
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
        titleLabel.text = "Введите url менеджера"
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "192.168. . :port/"
        textField.text = ipAddress
        textField.textAlignment = .right
        textField.delegate = self
        
        cancelButton.setTitle("Отмена", for: .normal)
        connectButton.setTitle("Соединиться", for: .normal)
        
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
        guard let urlString = textField.text else {
            return
        }
        
        for view in [titleLabel, textField, connectButton, cancelButton] {
            view.alpha = 0.5
            view.isUserInteractionEnabled = false
        }
        
        activityView.startAnimating()
        
        vm.connect(urlString: urlString) { (success) in
            DispatchQueue.main.async {
                for view in [self.titleLabel, self.textField, self.connectButton, self.cancelButton] {
                    view.alpha = 1
                    view.isUserInteractionEnabled = true
                }
                self.activityView.stopAnimating()
                if success {
                    self.dissmissIfAble()
                }
            }
        }
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

extension InputServerManagerIPAlertView: UITextFieldDelegate {
    
}
