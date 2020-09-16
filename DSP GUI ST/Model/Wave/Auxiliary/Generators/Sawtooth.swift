//
//  Sinusoid.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics

class Sawtooth: AudioWave {
    var frequencySignal: AudioWave?
    
    var amplitudeSignal: AudioWave?
    
    static var type: GenerationType { return .sawtooth }
    
    var isPlaying: Bool = true
    
    var frequency: (_ currentSample: Int) -> Double
    var amplitude: (_ currentSample: Int) -> Double
    var initialPhase: (_ currentSamle: Int) -> Double
    var sampleRate: Double
    var cachedPhase: Double = 0
    var fi: Double = 0
    func getSignal(at currentSample: Int) -> Double {
        /*let period = sampleRate/max(frequency(currentSample), 1)
        let signal =
            -amplitude(currentSample) + 2 * amplitude(currentSample)
                * Double(currentSample % Int(period))/period //sin(2*Double.pi*frequency(currentSample)*Double(abs(currentSample - Int(sampleRate)))/sampleRate + initialPhase(currentSample))
        //cachedPhase = signal
        return signal*/
        fi += Double.pi * Double(1 + (frequencySignal?.getSignal(at: currentSample) ?? 0)) * frequency(currentSample) / sampleRate
        return Double(-2 * amplitude(currentSample) / Double.pi * atan(1 / tan(fi)))
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
    required init(params: Params) {
        self.frequency = params.frequency
        self.amplitude = params.amplitude
        self.initialPhase = params.initialPhase
        self.sampleRate = params.sampleRate
    }
}

