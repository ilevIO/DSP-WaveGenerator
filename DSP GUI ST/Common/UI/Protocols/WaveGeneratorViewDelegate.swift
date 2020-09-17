//
//  WaveGeneratorViewDelegate.swift
//  DSP GUI ST
//
//  Created by Ilya Yelagov on 9/17/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

protocol WaveGeneratorViewDelegate: Any {
    var drawView: RefreshableViewDelegate { get }
    
    var amplitudeValue: Double { get set }
    var frequencyValue: Double { get set }
    var phaseValue: Double { get set }
    
    func updateValues()
}
