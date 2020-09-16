//
//  Square.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics

class Square: AudioWave {
    
    static var type: GenerationType { return .square }
    
    var frequencySignal: AudioWave?
    var amplitudeSignal: AudioWave?
    
    var initialPhase: (Int) -> Double
    
    var isPlaying: Bool = true
    
    var frequency: (Int) -> Double
    
    var amplitude: (Int) -> Double
    
    var sampleRate: Double
    var dutyCycleShare: (Int) -> Double
    var cachedPhase: Double = 0
    
    var fi: Double = 0
    
    func getSignal(at currentSample: Int) -> Double {
        let modulated = frequencySignal?.getSignal(at: currentSample) ?? 0
        fi += 2 * Double.pi * (1 + modulated) * frequency(currentSample) * 1 / sampleRate
        let cycle = 2 * Double.pi;
        return Double(amplitude(currentSample)
            * Double(fmod(fi, cycle) / cycle > self.dutyCycleShare(currentSample) ? -1 : 1))
    }

    init(frequency: @escaping (Int) -> Double, amplitude: @escaping (Int) -> Double, initialPhase: @escaping (Int) -> Double, sampleRate: Double, dutyCycleShare: @escaping (Int) -> Double) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.initialPhase = initialPhase
        self.sampleRate = sampleRate
        self.dutyCycleShare = dutyCycleShare
    }
    
    required init(params: Params) {
        self.frequency = params.frequency
        self.amplitude = params.amplitude
        self.initialPhase = params.initialPhase
        self.sampleRate = params.sampleRate
        self.dutyCycleShare = { _ in 0.5 }
    }
}
