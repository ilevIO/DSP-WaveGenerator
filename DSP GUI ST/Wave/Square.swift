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
    var frequencySignal: AudioWave?
    
    var amplitudeSignal: AudioWave?
    
    var initialPhase: (Int) -> Double
    
    static var type: GenerationType { return .square }
    
    var isPlaying: Bool = true
    
    var frequency: (Int) -> Double
    
    var amplitude: (Int) -> Double
    
    var sampleRate: Double
    var dutyCycleShare: (Int) -> Double
    var cachedPhase: Double = 0
    
    var fi: Double = 0
    /*var dutyCycle: Double {
        get {
            return self.dutyCycleShare*T
        }
    }*/
    /*var T: Double {
        get {
            return 1/frequency()
        }
        set {
            //frequency = 1/newValue
        }
    }*/
    
    init(frequency: @escaping (Int) -> Double, amplitude: @escaping (Int) -> Double, initialPhase: @escaping (Int) -> Double, sampleRate: Double, dutyCycleShare: @escaping (Int) -> Double) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.initialPhase = initialPhase
        self.sampleRate = sampleRate
        self.dutyCycleShare = dutyCycleShare
    }
    
   func remainder(_ a: Double, _ b: Double) -> Double {
        return a - Double(Int(a/b)*Int(b))
    }
    
    func getSignal(at currentSample: Int) -> Double {
        let modulated = frequencySignal?.getSignal(at: currentSample) ?? 0
        fi += 2 * Double.pi * (1 + modulated) * frequency(currentSample) * 1 / sampleRate
        var cycle = 2 * Double.pi;
        return Double(amplitude(currentSample)
            * Double(Double((Int(fi) % Int(cycle))) / cycle > self.dutyCycleShare(currentSample) ? 0 : 1))
        
        /*let currentSample = currentSample//%Int(self.sampleRate)
        let t = Double(currentSample % Int(sampleRate))/sampleRate
        var x: Double
        let T = 1/frequency(currentSample)
        let dutyCycle = self.dutyCycleShare(currentSample)*T
        //print("t.remainder(dividingBy: T)/T = \(t.remainder(dividingBy: T)/T)")
        if t.remainder(dividingBy: T)/T < dutyCycle {
            x = amplitude(currentSample)
        } else {
            x = 0-amplitude(currentSample)
        }
        return x*/
    }

    func getSignalSequence(from start: Int, to end: Int) -> [Double] {
        //let T = 1/frequency
        //let dutyCycle = self.dutyCycle * T
        let sequence = [Double]()
        for currentSample in start..<end {
            _ = currentSample//%Int(self.sampleRate)
            
            //sequence.append(getSignal(at: currentSample))
            
            
            /*let t = Double(currentSample)/sampleRate
            var x: Double
            //print("t.remainder(dividingBy: T)/T = \(t.remainder(dividingBy: T)/T)")
            if t.remainder(dividingBy: T)/T < dutyCycle {
                x = amplitude
            } else {
                x = 0-amplitude
            }*/
            
            //print("x: \(x)")
            /*if (i < (sz / 2)) {
                bptr.assumingMemoryBound(to: Int16.self).pointee = x
                bptr += 2   // increment by 2 bytes for next Int16 item
                bptr.assumingMemoryBound(to: Int16.self).pointee = x
                bptr += 2   // stereo, so fill both Left & Right channels
            }*/
            //print("currentSample: \(currentSample)")
            //currentSample = (currentSample + 1)%Int(self.sampleRate)
        }
        return sequence
    }
    
    required init(params: Params) {
        self.frequency = params.frequency
        self.amplitude = params.amplitude
        self.initialPhase = params.initialPhase
        self.sampleRate = params.sampleRate
        self.dutyCycleShare = { _ in 0.5 }
    }
}
