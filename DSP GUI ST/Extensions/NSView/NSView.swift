//
//  NSView.swift
//  DSP GUI ST
//
//  Created by Ilya Yelagov on 9/4/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation
import Cocoa

extension NSView {
    func fill(with subview: NSView, inset: CGFloat) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
        subview.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive = true
        subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive = true
    }
}
