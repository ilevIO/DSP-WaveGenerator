//
//  Label.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/16/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Cocoa

class Label: NSTextField {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.backgroundColor = .clear
        self.isBezeled = false
        self.isEditable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
