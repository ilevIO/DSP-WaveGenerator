//
//  AudioWave.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics

protocol AudioWave: class {
    var frequency: (_ currentSample: Int) -> Double { get set }
    var amplitude: (_ currentSample: Int) -> Double { get set }
    var initialPhase: (_ currentSample: Int) -> Double { get set }
    var sampleRate: Double { get set }
    var isPlaying: Bool { get set }
    
    var frequencySignal: AudioWave? { get set }
    var amplitudeSignal: AudioWave? { get set }
    
    static var type: GenerationType { get }
    func getType() -> GenerationType
    func getSignal(at currentSample: Int) -> Double
    func getParams() -> Params
    
    
    
    init(params: Params)
    //func getSignalSequence(from start: Int, to end: Int) -> [Double]

}
extension AudioWave {
    func getType() -> GenerationType {
        return Self.type
    }
    
    func getParams() -> Params {
        return Params(frequency: self.frequency, amplitude: self.amplitude, initialPhase: self.initialPhase, sampleRate: self.sampleRate)
    }
}
