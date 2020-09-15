//
//  Triangular.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics

class Triangular: AudioWave {
    var frequencySignal: AudioWave?
    
    var amplitudeSignal: AudioWave?
    
    var initialPhase: (Int) -> Double
    
    internal init(frequency: @escaping (Int) -> Double, amplitude: @escaping (Int) -> Double, initialPhase: @escaping (Int) -> Double, sampleRate: Double) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.initialPhase = initialPhase
        self.sampleRate = sampleRate
    }
    
    var frequency: (Int) -> Double
    
    var amplitude: (Int) -> Double
    
    var sampleRate: Double
    
    var isPlaying: Bool = true
    
    static var type: GenerationType { return .triangle }
    
    var fi: Double = 0
    
    func getSignal(at currentSample: Int) -> Double {
        fi += 2 * Double.pi * Double(1 + (frequencySignal?.getSignal(at: currentSample) ?? 0)) * frequency(currentSample) / sampleRate
        return Double(2 * amplitude(currentSample) / Double.pi * asin(sin(fi)));
        /*guard frequency(currentSample) > 0.000001 else { return 0 }
        var z: Double = 1
        let period = sampleRate/(frequency(currentSample))// + initialPhase(currentSample)
        let qNr = currentSample % Int(period) //Double(currentSample).remainder(dividingBy: period)
        //var x = sin(2*Double.pi*frequency(currentSample)*Double(abs(currentSample - Int(sampleRate)))/sampleRate + initialPhase(currentSample))
        /*if x < 0 {
            
        } else {
            
        }*/
        //x = x/abs(x)
        //return amplitude(currentSample) *
        if qNr < Int(period) / 2 {// || qNr > 3.0/4.0*period {
            return -amplitude(currentSample) + 2 * amplitude(currentSample) * Double(currentSample % Int(period)) / (period/2) //2 * amplitude(currentSample) * Double(currentSample % Int(period)) / (period/4) - amplitude(currentSample)
        } else {
            return amplitude(currentSample)
                - 2 * amplitude(currentSample) * Double(currentSample % Int(period/2)) / (period/2)
            //return amplitude(currentSample) - 2 * amplitude(currentSample) * Double(currentSample % Int(period)) / (period/4)
            //z = -Double(currentSample % Int(x))/x
        }
       // return 2 / Double.pi * 1/sin(sin(2*Double.pi*frequency(currentSample)*Double(currentSample)))*/
    }
    required init(params: Params) {
        self.frequency = params.frequency
        self.amplitude = params.amplitude
        self.initialPhase = params.initialPhase
        self.sampleRate = params.sampleRate
    }
    
}
