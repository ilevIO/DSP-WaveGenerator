//
//  MainViewController+Controller.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/16/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

extension MainViewController {
    class Presenter {
        
        enum ParamsVariation: String {
            case signal = "Signal"
            case frequency = "Frequency"
            case amplitude = "Amplitude"
        }
        
        var view: WaveGeneratorViewDelegate? {
            didSet {
                model.audioUnit.viewDelegate = view?.drawView
            }
        }
        var model: MainViewController.Model = .init()
        
        var isSettingChannelSelection = false
        var isPlaying = false
        
        var selectedSignalType: GenerationType = .sinusoid
        var currentVars: ParamsVariation = .signal
        var selectedChannel = 0
        
        var inputAmplitudeValue: Double { return view?.amplitudeValue ?? 0 }
        var inputFrequencyValue: Double { return view?.frequencyValue ?? 0}
        var inputPhaseValue: Double { return view?.phaseValue ?? 0 }
        
        var staticParams: Params {
            let frequency = inputFrequencyValue
            let amplitude = inputAmplitudeValue
            let phase = inputPhaseValue
            return .init(frequency: { _ in frequency }, amplitude: { _ in amplitude }, initialPhase: { _ in phase }, sampleRate: 44100)
        }
        
        func getSignal() -> AudioWave? {
            switch self.currentVars {
            case .signal: return model.audioUnit.currentWave
            case .frequency: return model.audioUnit.currentWave.frequencySignal
            case .amplitude: return model.audioUnit.currentWave.amplitudeSignal
            }
        }
        
        func getFrequencyRange() -> ClosedRange<Double> {
            switch self.currentVars {
            case .signal: return 0...20000
            case .frequency: return 0...100
            case .amplitude: return 0...100
            }
        }
        
        func getAmplitudeRange() -> ClosedRange<Double> {
            switch self.currentVars {
            case .signal: return 0...16000
            case .frequency: return 0...1
            case .amplitude: return 0...1
            }
        }
        
        func getRequiredPrecision() -> Int {
            switch self.currentVars {
            case .signal: return 0
            case .frequency: return 4
            case .amplitude: return 4
            }
        }
        
        func getChannelsTitle() -> [String] {
            var titles = [String]()
            var i = 1
            for channel in model.audioUnit.channels {
                titles.append("Channel \(i)  (\(channel.getType().rawValue))")
                i += 1
            }
            return titles
        }
        
        func variableParamsChanged(to paramsIndex: Int) {
            switch paramsIndex {
            case 0:
                self.currentVars = .signal
            case 1:
                self.currentVars = .frequency
            case 2:
                self.currentVars = .amplitude
            default:
                break
            }
        }
        
        func signalTypeChaned(to typeIndex: Int) {
            switch typeIndex {
                case 0:
                    self.selectedSignalType = .sinusoid

                case 1:
                    self.selectedSignalType = .square

                case 2:
                    self.selectedSignalType = .triangle

                case 3:
                    self.selectedSignalType = .sawtooth

                case 4:
                    self.selectedSignalType = .noise
                default: break
            }
        }
        
        func clearSignal() {
            switch self.currentVars {
            case .frequency:
                model.audioUnit.currentWave.frequencySignal = nil
            case .amplitude:
                model.audioUnit.currentWave.amplitudeSignal = nil
            default:
                break
            }
        }
        
        func createNewChannel() {
            model.addSignal(type: self.selectedSignalType)
            view?.updateValues()
        }
        
        func channelChanged(to index: Int) {
            model.selectWave(at: index)
            self.selectedChannel = index
            if !isSettingChannelSelection {
                view?.updateValues()
            }
        }
        
        func changeFrequencyModulationKind(to kindIndex: Int) {
            let frequencyValue = inputFrequencyValue
            let amplitudeValue = inputAmplitudeValue
            let params = Params(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
            switch kindIndex {
            case 0:
                model.audioUnit.currentWave.frequencySignal = Sinusoid(params: params)
            case 1:
                model.audioUnit.currentWave.frequencySignal = Square(params: params)
            case 2:
                model.audioUnit.currentWave.frequencySignal = Triangular(params: params)
            case 3:
                model.audioUnit.currentWave.frequencySignal = Sawtooth(params: params)
            case 5:
                model.audioUnit.currentWave.frequencySignal = NoiseWave(params: params)
            default:
                break
            }
        }
        
        func changeAmplitudeModulationKind(to kindIndex: Int) {
            let frequencyValue = inputFrequencyValue
            let amplitudeValue = inputAmplitudeValue
            let params = Params(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
            switch kindIndex {
            case 0:
                model.audioUnit.currentWave.amplitudeSignal = Sinusoid(params: params)
            case 1:
                model.audioUnit.currentWave.amplitudeSignal = Square(params: params)
            case 2:
                model.audioUnit.currentWave.amplitudeSignal = Triangular(params: params)
            case 3:
                model.audioUnit.currentWave.amplitudeSignal = Sawtooth(params: params)
            case 5:
                model.audioUnit.currentWave.amplitudeSignal = NoiseWave(params: params)
            default:
                break
            }
        }
        
        func modulationKindChanged(to kindIndex: Int) {
            switch self.currentVars {
            case .frequency:
                changeFrequencyModulationKind(to: kindIndex)
            case .amplitude:
                changeAmplitudeModulationKind(to: kindIndex)
            case .signal:
                let channelIndex = model.audioUnit.selectedWave
                let params = model.audioUnit.channels[channelIndex].getParams()
                switch kindIndex {
                case 0:
                    model.audioUnit.channels[channelIndex] = Sinusoid(params: params)
                case 1:
                    model.audioUnit.channels[channelIndex] = Square(params: params)
                    //add dutyCycle label
                case 2:
                    model.audioUnit.channels[channelIndex] = Triangular(params: params)
                case 3:
                    model.audioUnit.channels[channelIndex] = Sawtooth(params: params)
                case 4:
                    model.audioUnit.channels[channelIndex] = NoiseWave(params: params)
                default:
                    break
                }
                
                view?.updateValues()
            }
        }

        func amplitudeValueChanged(to newValue: Double) {
            switch currentVars {
            case .signal:
                model.audioUnit.currentWave.amplitude = { _ in newValue }
            case .frequency:
                model.audioUnit.currentWave.frequencySignal?.amplitude = { _ in newValue }
            case .amplitude:
                model.audioUnit.currentWave.amplitudeSignal?.amplitude = { _ in newValue }
            }
        }
        
        func phaseValueChanged(to newValue: Double) {
            switch currentVars {
            case .signal:
                model.audioUnit.currentWave.initialPhase = { _ in newValue }
            case .frequency:
                model.audioUnit.currentWave.frequencySignal?.initialPhase = { _ in newValue }
            case .amplitude:
                model.audioUnit.currentWave.amplitudeSignal?.initialPhase = { _ in newValue }
            }
        }
        
        func frequencyValueChanged(to newValue: Double) {
            switch currentVars {
            case .signal:
                model.audioUnit.currentWave.frequency = { _ in newValue }
            case .frequency:
                model.audioUnit.currentWave.frequencySignal?.frequency = { _ in newValue }
            case .amplitude:
                model.audioUnit.currentWave.amplitudeSignal?.frequency = { _ in newValue }
            }
        }
        
        func valueEntered() {
            let frequency = inputFrequencyValue
            let amplitude = inputAmplitudeValue
            switch self.currentVars {
            case .signal:
                model.audioUnit.currentWave.frequency = { _ in
                        return frequency
                    }
            case .frequency:
                model.audioUnit.currentWave.frequencySignal?.frequency = { _ in frequency }
            case .amplitude:
                model.audioUnit.currentWave.amplitudeSignal?.frequency = { _ in frequency }
            }
            
            switch self.currentVars {
            case .signal:
                model.audioUnit.currentWave.amplitude = { _ in
                        return amplitude
                    }
            case .frequency:
                model.audioUnit.currentWave.frequencySignal?.amplitude = { _ in amplitude }
            case .amplitude:
                model.audioUnit.currentWave.amplitudeSignal?.amplitude = { _ in amplitude }
            }
        }
        
        init(renderer: WaveRenderer) {
            model.audioUnit.channels.append(Sinusoid(
                frequency: { _ in Double( 0 )},
                amplitude: { _ in Double( 0 )},
                initialPhase: { _ in Double( 0 )}, sampleRate: 44100))
            model.audioUnit.renderer = renderer
        }
    }
    
}

extension MainViewController.Presenter {
    class MelodyWaveParams {
        var seconds: Double = 0
        let melodySpeed: Double = 60/70 //quorters per minute
        var sheetMusicIndex = 0
        var beginningSecond: Double = 0
        var delta = 1
        let relation = 1/KeyLength.fourth.rawValue
        let fadeTime: Double = 1
    }
    
    func getMelodyWave(for keyIndex: Int, params: MelodyWaveParams) -> AudioWave {
        var frequency: (_: Int) -> Double
        
        if keyIndex == 0 {
            frequency = { currentSample in
                let second: Double = Double(currentSample)/44100
                if abs(second - (Double(params.beginningSecond) + melody[params.sheetMusicIndex].length.rawValue*params.melodySpeed * params.relation)) < 0.001 {
                    params.beginningSecond = second
                    if params.sheetMusicIndex == melody.count-1 && params.delta == 1 || params.sheetMusicIndex == 0 && params.delta == -1 {
                        params.sheetMusicIndex = 16
                        params.beginningSecond = 0
                        self.model.audioUnit.renderer?.waves[0].coords = .init()
                        self.model.audioUnit.currentSample = 0
                    }
                    params.sheetMusicIndex += params.delta
                }
                return melody[params.sheetMusicIndex].notes[0].frequency //* 100
            }
        } else {
            frequency = { currentSample in
                    if melody[params.sheetMusicIndex].notes.count > keyIndex {
                        return melody[params.sheetMusicIndex].notes[keyIndex].frequency //* 100
                    }
                    return 0
            }
        }
        let signalParams = Params(
            frequency: frequency,
            amplitude: { currentSample in
                let second: Double = Double(currentSample)/44100
                var amplitude: Double = 10000*melody[params.sheetMusicIndex].velocity// * key.force
                if abs(second - Double(params.beginningSecond)) < 0.001 {
                    //amplitude = 10000
                } else {
                    amplitude = max(amplitude - amplitude * (second - params.beginningSecond)/params.fadeTime, 0)
                }
                return amplitude
        },
            initialPhase: { _ in return 0},
            sampleRate: 44100
        )
        switch selectedSignalType {
        case .sinusoid:
            return Sinusoid.init(params: signalParams)
        case .square:
            return Square.init(params: signalParams)
        case .triangle:
            return Triangular.init(params: signalParams)
        case .sawtooth:
            return Sawtooth.init(params: signalParams)
        case .noise:
            return NoiseWave.init(params: signalParams)
        }
    }
    
    func getMelodyWaveRightHand(for keyIndex: Int, params: MelodyWaveParams) -> AudioWave {
        var frequency: (_: Int) -> Double
        
        if keyIndex == 0 {
            frequency = { currentSample in
                let second: Double = Double(currentSample)/44100
                if abs(second - (Double(params.beginningSecond) + melodyRightHand[params.sheetMusicIndex].length.rawValue*params.melodySpeed * params.relation)) < 0.001 {
                    params.beginningSecond = second
                    if params.sheetMusicIndex == melodyRightHand.count-1 && params.delta == 1 || params.sheetMusicIndex == 0 && params.delta == -1 {
                        //params.delta = -params.delta
                        params.sheetMusicIndex = 0
                        params.beginningSecond = 0
                        self.model.audioUnit.renderer?.waves[0].coords = .init()
                        self.model.audioUnit.currentSample = 0
                    }
                    params.sheetMusicIndex += params.delta
                }
                return melodyRightHand[params.sheetMusicIndex].notes[0].frequency //* 100
            }
        } else {
            frequency = { currentSample in
                    if melodyRightHand[params.sheetMusicIndex].notes.count > keyIndex {
                        return melodyRightHand[params.sheetMusicIndex].notes[keyIndex].frequency //* 100
                    }
                    return 0
            }
        }
        let signalParams = Params(
            frequency: frequency,
            amplitude: { currentSample in
                let second: Double = Double(currentSample)/44100
                var amplitude: Double = 10000*melodyRightHand[params.sheetMusicIndex].velocity// * key.force
                if abs(second - Double(params.beginningSecond)) < 0.001 {
                    //amplitude = 10000
                } else {
                    amplitude = max(amplitude - amplitude * (second - params.beginningSecond)/params.fadeTime, 0)
                }
                return amplitude
        },
            initialPhase: { _ in return 0},
            sampleRate: 44100
        )
        switch selectedSignalType {
        case .sinusoid:
            return Sinusoid.init(params: signalParams)
        case .square:
            return Square.init(params: signalParams)
        case .triangle:
            return Triangular.init(params: signalParams)
        case .sawtooth:
            return Sawtooth.init(params: signalParams)
        case .noise:
            return NoiseWave.init(params: signalParams)
        }
         
    }
    
    func playMusic() {
        model.audioUnit.channels = [AudioWave]()
        model.audioUnit.renderer?.waves = [WaveVisualization]()
        
        let params = MelodyWaveParams()
        
        model.audioUnit.channels.append(getMelodyWave(for: 0, params: params))
        model.audioUnit.channels.append(getMelodyWave(for: 1, params: params))
        model.audioUnit.channels.append(getMelodyWave(for: 2, params: params))
        model.audioUnit.channels.append(getMelodyWave(for: 3, params: params))

        let rightParams = MelodyWaveParams()
        model.audioUnit.channels.append(getMelodyWaveRightHand(for: 0, params: rightParams))
        model.audioUnit.channels.append(getMelodyWaveRightHand(for: 1, params: rightParams))

        model.audioUnit.currentSample = 0
        model.audioUnit.enableSpeaker()

    }

    func updateSound() {
        DispatchQueue.main.async {
            let amplitude = self.inputAmplitudeValue
            let frequency = self.inputFrequencyValue
            let phase = self.inputPhaseValue
            self.model.audioUnit.currentWave.frequency = { _ in frequency }
            self.model.audioUnit.currentWave.initialPhase = { _ in phase }
            self.model.audioUnit.sampleRate = 44100
            self.model.audioUnit.currentWave.amplitude = { _ in amplitude }
            self.model.audioUnit.setToneTime(t: 100)
        }
    }
    
    func playTone() {
        isPlaying = true
        if isPlaying || true {
            DispatchQueue.main.async {
                self.model.audioUnit.sampleRate = 44100
                self.model.audioUnit.currentSample = 0
                self.model.audioUnit.currentWave.isPlaying = true
                self.model.audioUnit.enableSpeaker()
                self.model.audioUnit.setToneTime(t: 100)
            }
        } else {
            model.audioUnit.stop()
        }
    }
    
    func pause() {
        model.audioUnit.pause()
        isPlaying = false
    }
    
    func playAll() {
        isPlaying = true//!isPlaying
        if isPlaying || true {
            /*audioUnit.setFrequency(freq: Double(self.frequencyInput.stringValue) ?? 0)
            audioUnit.setPhase(phase: Double(self.phaseInput.stringValue) ?? 0)
            audioUnit.sampleRate = 44100
            audioUnit.setAmplitude(amplitude: Double(self.amplitudeInput.stringValue) ?? 0)
            audioUnit.enableSpeaker()
            audioUnit.setToneTime(t: 100)*/
            self.model.audioUnit.channels.forEach({ $0.isPlaying = true })
            self.model.audioUnit.enableSpeaker()
            self.model.audioUnit.setToneTime(t: 100)
            /*DispatchQueue.main.async {

                let amplitude = Double(self.amplitudeInput.stringValue) ?? 0
                let frequency = Double(self.frequencyInput.stringValue) ?? 0
                
                self.audioUnit.channels[self.selectedChannel].frequency = { _ in frequency }// setFrequency(freq: Double(self.frequencyInput.stringValue) ?? 0)
                //audioUnit//.setPhase(phase: Double(self.phaseInput.stringValue) ?? 0)
                self.audioUnit.sampleRate = 44100
                self.audioUnit.channels[self.selectedChannel].amplitude = { _ in amplitude } //.setAmplitude(amplitude: Double(self.amplitudeInput.stringValue) ?? 0)
                self.audioUnit.enableSpeaker()
                self.audioUnit.setToneTime(t: 100)
            }*/

        } else {
            model.audioUnit.stop()
        }
    }
    
    func stop() {
        model.audioUnit.stop()
        self.isPlaying = model.audioUnit.audioRunning
    }
    
    func refreshView() {
        
    }
}
