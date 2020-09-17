//
//  DrawView.swift
//  DSP GUI ST
//
//  Created by Ilya Yelagov on 9/3/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation
import Cocoa

class WavesDrawView: NSView {
    var renderer: WaveRenderer?
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current?.cgContext else { return }

        context.addRect(dirtyRect)
        context.setFillColor(NSColor.white.cgColor)
        context.fillPath()
        //TODO: move
        renderer?.width = self.frame.width
        renderer?.height = self.frame.height
        renderer?.draw(to: context)

    }
}

extension WavesDrawView: RefreshableViewDelegate {
    func refresh() {
        self.setNeedsDisplay(self.frame)
    }
    
    
}
