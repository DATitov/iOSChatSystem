//
//  CellView.swift
//  iOSChatSystemServerManager
//
//  Created by Dmitrii Titov on 09.03.2018.
//  Copyright © 2018 Dmitriy Titov. All rights reserved.
//

import Cocoa

class CellView: NSTableRowView {

    let label = NSTextView()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupUI()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
    }
    
    func setupUI() {
        addSubview(label)
    }
    
    override func layout() {
        super.layout()
        
        label.frame = bounds
    }
    
}
