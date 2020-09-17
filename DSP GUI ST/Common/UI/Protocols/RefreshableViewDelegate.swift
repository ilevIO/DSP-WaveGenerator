//
//  RefreshableViewDelegate.swift
//  DSP GUI ST
//
//  Created by Ilya Yelagov on 9/17/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Cocoa

protocol RefreshableViewDelegate: NSView {
    var renderer: WaveRenderer? { get set }
    func refresh()
}
