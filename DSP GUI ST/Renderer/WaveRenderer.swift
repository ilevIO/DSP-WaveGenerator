//
//  WaveRenderer.swift
//  DSP GUI ST
//
//  Created by Ilya Yelagov on 9/4/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation
import CoreGraphics
import Cocoa

//TODO: move:
struct WaveVisualization {
    var coords: [CGPoint]
    var color: CGColor
}


class WaveRenderer {
    let upperBound: CGFloat = 100000
    let widthBound: CGFloat = 1 * 44100
    var waves = [WaveVisualization]()
    var width: CGFloat = 1000
    var height: CGFloat = 1000
    var originY: CGFloat { return height/2 }
    let secondSamples: CGFloat = 44100
    
    func draw(to context: CGContext) {
        context.setLineWidth(widthBound / width * 4)//*width*/)
        var transformation = CGAffineTransform.init(translationX: 0, y: originY)
        transformation = transformation.scaledBy(x: 1.0, y: height/upperBound)
        context.saveGState()
        context.translateBy(x: 0, y: originY)
        context.scaleBy(x: width/widthBound, y: height/upperBound)
        
        for wave in waves where !wave.coords.isEmpty {
            context.setStrokeColor(wave.color)
            let path = CGMutablePath()
            //path.move(to: wave.coords.first/*?.applying(transformation)*/ ?? CGPoint.zero)
            var coordIndex = min(max(1, wave.coords.count-Int(widthBound) - (wave.coords.count-Int(widthBound)) % 100), wave.coords.count-1)
            context.translateBy(x: -CGFloat(coordIndex), y: 0)
            path.move(to: wave.coords[coordIndex])
            //var pointsRendered = 0
            while coordIndex < wave.coords.count - 1 {
                path.addLine(to: wave.coords[coordIndex])//.applying(transformation))
                coordIndex += 100 //coordIndex + 100, wave.coords.count - 1)
                //pointsRendered += 1
            }
            
            path.addLine(to: wave.coords[wave.coords.count - 1])
            
            //print("Sample: \(wave.coords[wave.coords.count - 1].x) pointsRendered: \(pointsRendered)")
            context.addPath(path)
            context.strokePath()
            context.translateBy(x: CGFloat(coordIndex), y: 0)
        }
        context.restoreGState()
    }
}
