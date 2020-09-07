//
//  Mixer.swift
//  DSP GUI ST
//
//  Created by Ilya Yelagov on 9/3/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics

protocol AudioChanel: class {
    var frequency: (_ currentSample: Int) -> Double { get set }
    var amplitude: (_ currentSample: Int) -> Double { get set }
    var initialPhase: (_ currentSample: Int) -> Double { get set }
    var sampleRate: Double { get set }
    var isPlaying: Bool { get set }
    static var type: GenerationType { get }
    func getType() -> GenerationType
    func getSignal(at currentSample: Int) -> Double

    //func getSignalSequence(from start: Int, to end: Int) -> [Double]

}
extension AudioChanel {
    func getType() -> GenerationType {
        return Self.type
    }
}

class Sinusoid: AudioChanel {
    static var type: GenerationType { return .sinusoid }
    
    var isPlaying: Bool = true
    
    var frequency: (_ currentSample: Int) -> Double
    var amplitude: (_ currentSample: Int) -> Double
    var initialPhase: (_ currentSamle: Int) -> Double
    var sampleRate: Double
    var cachedPhase: Double = 0
    
    func getSignal(at currentSample: Int) -> Double {
        let signal =
            amplitude(currentSample)
        * sin(2*Double.pi*frequency(currentSample)*Double(currentSample % Int(sampleRate))/sampleRate + initialPhase(currentSample))
        cachedPhase = signal
        return signal
    }
    
    func getSignalSequence(from start: Int, to end: Int) -> [Double] {
        var signalSequence = [Double]()
        for currentSample in start..<end {
            
        }
        return signalSequence
    }
    init(frequency: @escaping (Int) -> Double, amplitude: @escaping (Int) -> Double, initialPhase: @escaping (Int) -> Double, sampleRate: Double) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.initialPhase = initialPhase
        self.sampleRate = sampleRate
    }
}

class Square: AudioChanel {
    var initialPhase: (Int) -> Double
    
    static var type: GenerationType { return .square }
    
    var isPlaying: Bool = true
    
    var frequency: (Int) -> Double
    
    var amplitude: (Int) -> Double
    
    var sampleRate: Double
    var dutyCycleShare: (Int) -> Double
    var cachedPhase: Double = 0
    
    
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
    
    func getSignal(at currentSample: Int) -> Double {
        let currentSample = currentSample//%Int(self.sampleRate)
        let t = Double(currentSample)/sampleRate
        var x: Double
        let T = 1/frequency(currentSample)
        let dutyCycle = self.dutyCycleShare(currentSample)*T
        //print("t.remainder(dividingBy: T)/T = \(t.remainder(dividingBy: T)/T)")
        if t.remainder(dividingBy: T)/T < dutyCycle {
            x = amplitude(currentSample)
        } else {
            x = 0-amplitude(currentSample)
        }
        return x
    }

    func getSignalSequence(from start: Int, to end: Int) -> [Double] {
        //let T = 1/frequency
        //let dutyCycle = self.dutyCycle * T
        var sequence = [Double]()
        for currentSample in start..<end {
            let currentSample = currentSample//%Int(self.sampleRate)
            
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
}

class Triangular: AudioChanel {
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
    
    func getSignal(at currentSample: Int) -> Double {
        return amplitude(currentSample) / Double.pi * asin(sin(2*Double.pi*frequency(currentSample)*Double(currentSample)))
    }
    
    
}

import CoreAudio
import AudioUnit
import AVFoundation

class Mixer {
    var channels = [AudioChanel]()
    var selectedChannel = 0
    var currentChannel: AudioChanel {
        return self.channels[selectedChannel]
    }
    
    var currentSample: Int = 0
    var sampleRate : Double = 44100.0    // typical audio sample rate
    var toneCount : Int32 = 0       // number of samples of tone to play.  0 for silence
    
    var auAudioUnit: AUAudioUnit! = nil     // placeholder for RemoteIO Audio Unit
    var avActive     = false             // AVAudioSession active flag
    var audioRunning = false             // RemoteIO Audio Unit running flag
    
    var viewDelegate: NSView?

    var renderer: WaveRenderer?
    
    func setToneTime(t: Double) {
        toneCount = Int32(t * sampleRate);
    }
    
    func enableSpeaker() {

        if audioRunning {

            print("returned")
            return

        }           // return if RemoteIO is already running

        do {        // not running, so start hardware
            currentSample = 0
            self.renderer?.waves = [.init(coords: .init(), color: NSColor.red.cgColor)]
            let audioComponentDescription = AudioComponentDescription(
                componentType: kAudioUnitType_Output,
                componentSubType: kAudioUnitSubType_SystemOutput, // kAudioUnitSubType_RemoteIO,
                componentManufacturer: kAudioUnitManufacturer_Apple,
                componentFlags: 0,
                componentFlagsMask: 0 )

            if (auAudioUnit == nil) {

                try auAudioUnit = AUAudioUnit(componentDescription: audioComponentDescription)

                let bus0 = auAudioUnit.inputBusses[0]

                let audioFormat = AVAudioFormat(
                    commonFormat: AVAudioCommonFormat.pcmFormatInt16,   // short int samples
                    sampleRate: Double(sampleRate),
                    channels:AVAudioChannelCount(2),
                    interleaved: true )                                 // interleaved stereo

                try bus0.setFormat(audioFormat ?? AVAudioFormat())  //      for speaker bus

                auAudioUnit.outputProvider = { (    //  AURenderPullInputBlock?
                    actionFlags,
                    timestamp,
                    frameCount,
                    inputBusNumber,
                    inputDataList ) -> AUAudioUnitStatus in

                    self.fillSpeakerBuffer(inputDataList: inputDataList, frameCount: frameCount)
                    return(0)
                }
            }

            auAudioUnit.isOutputEnabled = true
            toneCount = 0

            try auAudioUnit.allocateRenderResources()  //  v2 AudioUnitInitialize()
            try auAudioUnit.startHardware()            //  v2 AudioOutputUnitStart()
            audioRunning = true

        } catch /* let error as NSError */ {
            print("error 2 \(error)")
        }


    }
    
    func stop() {
        self.channels[selectedChannel].isPlaying = false
        if channels.filter({ $0.isPlaying }).isEmpty {
            self.pause()
        } else {
            self.enableSpeaker()
        }
    }
    
    func pause() {
        if (audioRunning) {
            auAudioUnit.stopHardware()
            audioRunning = false
        }
    }
    
    private func fillSpeakerBuffer(     // process RemoteIO Buffer for output
        inputDataList : UnsafeMutablePointer<AudioBufferList>, frameCount : UInt32 ) {
        let inputDataPtr = UnsafeMutableAudioBufferListPointer(inputDataList)
        let nBuffers = inputDataPtr.count
        if (nBuffers > 0) {

            let mBuffers: AudioBuffer = inputDataPtr[0]
            let count = Int(frameCount)

            let sz = Int(mBuffers.mDataByteSize)
            let bufferPointer = UnsafeMutableRawPointer(mBuffers.mData)
            if var bptr = bufferPointer {
                for i in 0..<(count) {
                    var xn: Double = 0
                    for channelIndex in 0..<channels.count where channels[channelIndex].isPlaying {
                        let dX = channels[channelIndex].getSignal(at: currentSample)
                        xn += dX
                    }
                    
                    let x: Int16 = Int16(max(min(xn + 0.5, Double(Int16.max - 1)), Double(Int16.min + 1)))
                    
                    if (i < (sz / 2)) {
                        bptr.assumingMemoryBound(to: Int16.self).pointee = x
                        bptr += 2   // increment by 2 bytes for next Int16 item
                        bptr.assumingMemoryBound(to: Int16.self).pointee = x
                        bptr += 2   // stereo, so fill both Left & Right channels
                    }
                    DispatchQueue.main.async(flags: .barrier)/*global(qos: .default).async(flags: .barrier)*/ {
                        if /*currentSample % 1 == 0 &&*/ (self.renderer?.waves.count ?? 0) > 0 {
                            self.renderer?.waves[0].coords.append(.init(x: CGFloat(self.currentSample), y: CGFloat(xn)))
                        } else {
                            //print("Render error")
                        }
                    }
                    currentSample = currentSample + 1//%Int(self.sampleRate)
                }
            }
            DispatchQueue.main.async {
                if self.currentSample % Int(self.sampleRate/60) < count, let rect = self.viewDelegate?.visibleRect {
                    self.viewDelegate?.setNeedsDisplay(rect)
                }
            }
            // Speaker Output == play tone at frequency f0
            /*if (self.amplitude > 0)
                && (self.toneCount > 0 )
            {
                // audioStalled = false

                var A = self.amplitude
                A = min(A, 32767)   //max volume?
                //if v > 32767 {
                //    v = 32767
                //}
                let sz = Int(mBuffers.mDataByteSize)

                var xn = self.phY        // capture from object for use inside block
                let d = 2.0 * Double.pi * self.frequency / self.sampleRate     // phase delta   2pi*f/N

                //sinusoid(mBuffers: mBuffers, count: count, d: d, xn: &xn, sz: sz)
                let bufferPointer = UnsafeMutableRawPointer(mBuffers.mData)
                if var bptr = bufferPointer {
                    if self.type == .sinusoid {
                        print(count)
                        for i in 0..<(count) {
                            let u = sin(xn)             // create a sinewave
                            xn += d
                            if (xn > 2.0 * Double.pi) {
                                xn -= 2.0 * Double.pi
                            }
                            let x = Int16(A * u + 0.5)      // scale & round

                            if (i < (sz / 2)) {
                                bptr.assumingMemoryBound(to: Int16.self).pointee = x
                                bptr += 2   // increment by 2 bytes for next Int16 item
                                bptr.assumingMemoryBound(to: Int16.self).pointee = x
                                bptr += 2   // stereo, so fill both Left & Right channels
                            }
                            //print("currentSample: \(currentSample)")
                            currentSample = (currentSample + 1)%Int(self.sampleRate)
                        }
                    } else if self.type == .square {
                        print(count)
                        //let dcOffset = self.amplitude * (2.0 * self.dutyCycle - 1.0)
                        let T = 1/frequency
                        let dutyCycle = self.dutyCycle * T
                        for i in 0..<(count) {
                            let t = Double(currentSample)/sampleRate
                            var x: Int16
                            //print("t.remainder(dividingBy: T)/T = \(t.remainder(dividingBy: T)/T)")
                            if t.remainder(dividingBy: T)/T < dutyCycle {
                                x = Int16(amplitude + 0.5)
                            } else {
                                x = Int16(0-amplitude + 0.5)
                            }
                            //print("x: \(x)")
                            if (i < (sz / 2)) {
                                bptr.assumingMemoryBound(to: Int16.self).pointee = x
                                bptr += 2   // increment by 2 bytes for next Int16 item
                                bptr.assumingMemoryBound(to: Int16.self).pointee = x
                                bptr += 2   // stereo, so fill both Left & Right channels
                            }
                            //print("currentSample: \(currentSample)")
                            currentSample = (currentSample + 1)%Int(self.sampleRate)
                        }
                    } else if self.type == .triangle {
                        
                    }
                }
                    
                self.phY        =   xn                   // save sinewave phase
                self.toneCount  -=  Int32(frameCount)   // decrement time remaining
            } else {
                // audioStalled = true
                memset(mBuffers.mData, 0, Int(mBuffers.mDataByteSize))  // silence
            }*/
        }
    }

}
