//
//  Mixer.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation
import Cocoa
import CoreAudio
import AudioUnit
import AVFoundation

class Mixer {
    var channels = [AudioWave]()  //refactor to "waves"
    var selectedWave = 0
    var currentWave: AudioWave {
        return self.channels[selectedWave]
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
        self.channels[selectedWave].isPlaying = false
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
        inputDataList: UnsafeMutablePointer<AudioBufferList>, frameCount: UInt32) {
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
                        let dX = channels[channelIndex].getSignal(at: currentSample) * (1 + (channels[channelIndex].amplitudeSignal?.getSignal(at: currentSample) ?? 0))
                        xn += dX
                    }
                    
                    let x: Int16 = Int16(max(min(xn + 0.5, Double(Int16.max - 1)), Double(Int16.min + 1)))
                    
                    if (i < (sz / 2)) {
                        bptr.assumingMemoryBound(to: Int16.self).pointee = x
                        bptr += 2   // increment by 2p bytes for next Int16 item
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
                /*if /*currentSample % 1 == 0 &&*/ (self.renderer?.waves.count ?? 0) > 0 {
                    self.renderer?.waves[0].coords.append(contentsOf:  Array.init(repeating: .init(x: CGFloat(self.currentSample), y: CGFloat(firstXn)), count: count))
                } else {
                    //print("Render error")
                }*/
                if self.currentSample % Int(self.sampleRate/60) < count, let rect = self.viewDelegate?.visibleRect {
                    self.viewDelegate?.setNeedsDisplay(rect)
                }
            }
        }
        /*} else {
            // audioStalled = true
            memset(mBuffers.mData, 0, Int(mBuffers.mDataByteSize))  // silence
        }*/
    }

}
