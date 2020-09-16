//
//  WaveParams.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/16/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

class Params {
    var frequency: (_ currentSample: Int) -> Double
    var amplitude: (_ currentSample: Int) -> Double
    var initialPhase: (_ currentSamle: Int) -> Double
    var sampleRate: Double = 44100
    
    init(frequency: @escaping (Int) -> Double, amplitude: @escaping (Int) -> Double, initialPhase: @escaping (Int) -> Double, sampleRate: Double) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.initialPhase = initialPhase
        self.sampleRate = sampleRate
    }
}
