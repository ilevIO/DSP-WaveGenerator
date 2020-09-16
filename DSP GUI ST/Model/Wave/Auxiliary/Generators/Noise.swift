//
//  Noise.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/15/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

class NoiseWave: AudioWave {
    var frequencySignal: AudioWave?
    
    var amplitudeSignal: AudioWave?
    
    required init(params: Params) {
        self.frequency = params.frequency
        self.amplitude = params.amplitude
        self.initialPhase = params.initialPhase
        self.sampleRate = params.sampleRate
    }
    
    static var type: GenerationType { return .sinusoid }
    
    var isPlaying: Bool = true
    
    var frequency: (_ currentSample: Int) -> Double
    var amplitude: (_ currentSample: Int) -> Double
    var initialPhase: (_ currentSamle: Int) -> Double
    var sampleRate: Double
    var cachedPhase: Double = 0

    var fi: Double = 0
    
    func getSignal(at currentSample: Int) -> Double {
        fi += 2 * Double.pi * Double.random(in: 0..<1) * Double(1 + (frequencySignal?.getSignal(at: currentSample) ?? 0)) * frequency(currentSample) / sampleRate
        
        let signal = amplitude(currentSample) * sin(fi)
        return signal
    }
    
    func getSignalSequence(from start: Int, to end: Int) -> [Double] {
        return [0]
    }
    
    init(frequency: @escaping (Int) -> Double, amplitude: @escaping (Int) -> Double, initialPhase: @escaping (Int) -> Double, sampleRate: Double) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.initialPhase = initialPhase
        self.sampleRate = sampleRate
    }
}
