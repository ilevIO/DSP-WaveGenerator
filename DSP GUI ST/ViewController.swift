//
//  ViewController.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/1/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Cocoa
import Foundation
import CoreAudio
import AudioUnit
import AVFoundation

enum GenerationType: String {
    case sinusoid = "Sinusoid"
    case square = "Square"
    case triangle = "Triangle"
    case sawtooth = "Sawtooth"
    case noise = "Noise"
}

class Label: NSTextField {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        //self.stringValue = "My awesome label"
        //self.backgroundColor = .white
        self.backgroundColor = .clear
        self.isBezeled = false
        self.isEditable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: NSViewController {
    //Controller:
    enum ParamsVariation {
        case signal
        case frequency
        case amplitude
    }
    var currentVars: ParamsVariation = .signal
    ///////]
    @objc func onParamsChange(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
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
    //MARK: -subviews
    var paramsVarChangeSwitch = NSSegmentedControl(labels: ["Signal", "Frequency", "Amplitude"], trackingMode: .selectOne, target: nil, action: #selector(onParamsChange(_:)))
    
    var audioUnit = Mixer()//ToneOutputUnit()
    var drawView = WavesDrawView()
    var amplitudeInput = NSTextField()
    var phaseInput = NSTextField()
    var frequencyInput = NSTextField()
    var isPlaying = false
    var amplitudeLabel = Label()//NSText(frame: .init(x: 50, y: 50, width: 60, height: 12))
    var phaseLabel = Label()//NSText(frame: .init(x: 50, y: 50, width: 60, height: 12))
    var frequencyLabel = Label()//NSText(frame: .init(x: 50, y: 50, width: 60, height: 12))
    var modulationLabel = Label()
    var frequencyModulationKindSwitch = NSSegmentedControl(labels: ["Sinusoid", "Square", "Triangle", "Sawtooth", "Noise"], trackingMode: .selectOne, target: nil, action: #selector(onFrequencyModulationKindChanged(_:)))
    var amplitudeModulationKindSwitch = NSSegmentedControl(labels: ["Sinusoid", "Square", "Triangle", "Sawtooth", "Noise"], trackingMode: .selectOne, target: nil, action: #selector(onAmplitudeModulationKindChanged(_:)))
    var btnPlayMusic = NSButton()
    //MARK: -control
    var renderer = WaveRenderer()
    var selectedChannel = 0
    var channelsList = NSPopUpButton(title: "Channels", target: nil, action: #selector(onChannelChanged(_:)))// NSPopUpButton(frame: .zero, pullsDown: true)
    //var selectedCh
    
    var signalKindSwitch = NSSegmentedControl(labels: ["Sinusoid", "Square", "Triangle", "Sawtooth", "Noise"], trackingMode: .selectOne, target: nil, action: #selector(onKindChanged(_:)))
    
    var amplitudeSlider: NSSlider = NSSlider(target: nil, action: #selector(amplitudeSliderChanged(_:)))
    var phaseSlider: NSSlider = NSSlider(target: nil, action: #selector(phaseSliderChanged(_:)))
    var frequencySlider: NSSlider = NSSlider(target: nil, action: #selector(frequencySliderChanged(_:)))
    
    var channelSelectiongSetting = false
    
    @objc func onChannelChanged(_ sender: NSPopUpButton) {
        let index = sender.indexOfSelectedItem

        let amplitude = self.amplitudeInput.doubleValue
        let frequency = self.frequencyInput.doubleValue
        let phase = self.phaseInput.doubleValue
        if index == sender.itemArray.count - 1 {
            
            switch signalKindSwitch.selectedSegment {
            case 0:
                audioUnit.channels.insert(Sinusoid(
                    frequency: { _ in frequency },
                    amplitude: { _ in amplitude },
                    initialPhase: { _ in phase }, sampleRate: audioUnit.sampleRate), at: 0)
            case 1:
                audioUnit.channels.insert(Square(
                    frequency: { _ in frequency },
                    amplitude: { _ in amplitude },
                    initialPhase: { _ in phase },
                    sampleRate: audioUnit.sampleRate,
                    dutyCycleShare: { _ in 0.5 }), at: 0)
            case 2:
                audioUnit.channels.insert(Triangular(
                    frequency: { _ in frequency },
                    amplitude: { _ in amplitude },
                    initialPhase: { _ in phase },
                    sampleRate: audioUnit.sampleRate), at: 0)

                //add dutyCycle label
            /*case 2:
                audioUnit.type = .triangle
            case 3:
                audioUnit.type = .sawtooth
            case 5:
                audioUnit.type = .noise*/
            default:
                break
            }
            //audioUnit.renderer?.waves.append(.init(coords: [CGPoint](), color: NSColor.green.cgColor))
            self.updateValues()
            audioUnit.selectedWave = 0
        } else {
            audioUnit.selectedWave = index

            if !channelSelectiongSetting {
                self.updateValues()
            }
        }
    }
    
    func updateValues() {
        self.channelsList.removeAllItems()
        /*self.channelsList.addItems(withTitles:
            self.audioUnit.channels.map({
                $0.getType().rawValue
            })
        )*/
        var i = 1
        for channel in self.audioUnit.channels {
            //self.channelsList.addItem(withTitle: channel.getType().rawValue)

            self.channelsList.insertItem(withTitle: "Channel \(i)  (\(channel.getType().rawValue))", at: 0)
            //self.channelsList.selectItem(at: 0)
            i += 1
        }
        self.channelsList.addItem(withTitle: "New...")
        channelSelectiongSetting = true
        self.channelsList.selectItem(at: self.audioUnit.selectedWave)
        channelSelectiongSetting = false
        self.frequencySlider.doubleValue = self.audioUnit.currentWave.frequency(0)
        self.amplitudeSlider.doubleValue = self.audioUnit.currentWave.amplitude(0)
        
        self.frequencyInput.doubleValue = self.audioUnit.currentWave.frequency(0)
        let qNr = amplitudeSlider.intValue.quotientAndRemainder(dividingBy: 1000)
        if qNr.quotient > 0 {
            self.amplitudeInput.stringValue = "\(qNr.quotient)\(qNr.remainder)"

        } else {
            self.amplitudeInput.stringValue = "\(qNr.remainder)"
        }
        
        switch audioUnit.currentWave.getType() {
        case .sinusoid:
            self.signalKindSwitch.selectedSegment = 0
        case .square:
            self.signalKindSwitch.selectedSegment = 1
        case .triangle:
            self.signalKindSwitch.selectedSegment = 2
        default:
            break
        }
        //self.pha.doubleValue = self.audioUnit.currentChannel.amplitude(0)
        
    }
    
    @objc func amplitudeSliderChanged(_ sender: NSSlider) {
        let qNr = sender.intValue.quotientAndRemainder(dividingBy: 1000)
        if qNr.quotient > 0 {
            self.amplitudeInput.stringValue = "\(qNr.quotient)\(qNr.remainder)"

        } else {
            self.amplitudeInput.stringValue = "\(qNr.remainder)"
        }
        let amplitudeValue = self.amplitudeInput.doubleValue
        switch self.currentVars {
        case .signal:
            self.audioUnit.currentWave.amplitude = { _ in amplitudeValue }
        case .frequency:
            self.amplitudeFrequencyModulation = amplitudeValue/1000
        default:
            break
        }
        //updateSound()
    }
    
    @objc func phaseSliderChanged(_ sender: NSSlider) {
        let qNr = sender.intValue.quotientAndRemainder(dividingBy: 1000)
        if qNr.quotient > 0 {
            self.phaseInput.stringValue = "\(qNr.quotient)\(qNr.remainder)"

        } else {
            self.phaseInput.stringValue = "\(qNr.remainder)"
        }
        let phaseValue = self.phaseInput.doubleValue
        self.audioUnit.currentWave.initialPhase = { _ in phaseValue }
        //updateSound()
    }
    
    @objc func frequencySliderChanged(_ sender: NSSlider) {
        let qNr = sender.intValue.quotientAndRemainder(dividingBy: 1000)
        if qNr.quotient > 0 {
            self.frequencyInput.stringValue = "\(qNr.quotient)\(qNr.remainder)"

        } else {
            self.frequencyInput.stringValue = "\(qNr.remainder)0"
        }
        let frequencyValue = self.frequencyInput.doubleValue
        switch self.currentVars {
        case .signal: self.audioUnit.currentWave.frequency = { _ in frequencyValue }
        case .frequency: self.frequencyFrequencyModulation = frequencyValue
        case .amplitude: self.frequencyAmplitudeModulation = frequencyValue
        }
        //updateSound()
    }
    
    @objc func onKindChanged(_ sender: NSSegmentedControl) {
        let channelIndex = audioUnit.channels.count - audioUnit.selectedWave - 1
        let params = audioUnit.channels[channelIndex].getParams()
        switch sender.selectedSegment {
        case 0:
            audioUnit.channels[channelIndex] = Sinusoid(
                frequency: audioUnit.channels[channelIndex].frequency,
                amplitude: audioUnit.channels[channelIndex].amplitude,
                initialPhase: audioUnit.channels[channelIndex].initialPhase, sampleRate: audioUnit.sampleRate)
        case 1:
            audioUnit.channels[channelIndex] = Square(
                frequency: audioUnit.channels[channelIndex].frequency,
                amplitude: audioUnit.channels[channelIndex].amplitude,
                initialPhase: audioUnit.channels[channelIndex].initialPhase,
                sampleRate: audioUnit.sampleRate,
                dutyCycleShare: { _ in 0.5 })
            //add dutyCycle label
        case 2:
            audioUnit.channels[channelIndex] = Triangular(
            frequency: audioUnit.channels[channelIndex].frequency,
            amplitude: audioUnit.channels[channelIndex].amplitude,
            initialPhase: audioUnit.channels[channelIndex].initialPhase, sampleRate: audioUnit.sampleRate)
        case 3:
            audioUnit.channels[channelIndex] = Sawtooth(params: params)
        case 4:
            audioUnit.channels[channelIndex] = NoiseWave(params: params)
        /*case 3:
            audioUnit.type = .sawtooth
        case 5:
            audioUnit.type = .noise*/
        default:
            break
        }
        
        updateValues()
    }
    
    var frequencyFrequencyModulation: Double = 2
    var amplitudeFrequencyModulation: Double = 1
    var phaseFrequencyModulation: Double = 0
    
    var frequencyAmplitudeModulation: Double = 2
    var amplitudeAmplitudeModulation: Double = 1
    var phaseAmplitudeModulation: Double = 0
    
    @objc func onFrequencyModulationKindChanged(_ sender: NSSegmentedControl) {
        let frequencyValue = self.frequencyInput.doubleValue / 1000
        let amplitudeValue = self.amplitudeInput.doubleValue / 1000
        
        if self.currentVars == .frequency || self.currentVars == .signal {
        switch sender.selectedSegment {
        case 0:
            audioUnit.currentWave.frequencySignal = Sinusoid(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
            /*audioUnit.currentWave.frequency = { currentSample in
                /*print(currentSample)
                //print("frequency: \(frequencyValue * abs(sin(Double(currentSample)/44100*Double.pi)))")
                var c: Int
                let qNr = currentSample.quotientAndRemainder(dividingBy: 44100)
                if qNr.quotient % 2 == 0 {
                    c = qNr.remainder
                } else {
                    c = -qNr.remainder
                }
                //let result = frequencyValue + frequencyValue * sin(Double(currentSample)/44100*Double.pi*2)
                //print("...\(result)")
                frV += 0.5*/
                //let result = frV
                return frequencyValue * sin(2*Double.pi*Double(abs(currentSample - Int(44100)))/44100 + 0)
            }*/
            /*audioUnit.channels[audioUnit.selectedChannel] = Sinusoid(
                frequency: audioUnit.channels[audioUnit.selectedChannel].frequency,
                amplitude: audioUnit.channels[audioUnit.selectedChannel].amplitude,
                initialPhase: audioUnit.channels[audioUnit.selectedChannel].initialPhase, sampleRate: audioUnit.sampleRate)*/
        case 1:
            /*audioUnit.currentWave.frequency = { currentSample in
                let period = Int(currentSample / 44100)
                //print(period)
                //print(Double((0-1) * (period % 2) + ((period + 1) % 2)))
                return frequencyValue + frequencyValue * self.frequencyFrequencyModulation * 0.01 *
                    Double((0-1) * (period % 2) + ((period + 1) % 2))
            }*/
            audioUnit.currentWave.frequencySignal = Square(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100, dutyCycleShare: { _ in 0.5 })
            /*audioUnit.channels[audioUnit.selectedChannel] = Square(
                frequency: audioUnit.channels[audioUnit.selectedChannel].frequency,
                amplitude: audioUnit.channels[audioUnit.selectedChannel].amplitude,
                initialPhase: 0,
                sampleRate: audioUnit.sampleRate,
                dutyCycleShare: { _ in 0.5 })
            //add dutyCycle label*/
        case 2:
            audioUnit.currentWave.frequencySignal = Triangular(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
            /*audioUnit.currentWave.frequency = { currentSample in
                let period = max(Double(currentSample) / 44100, 1)
                let qNr = currentSample % Int(period)
                if qNr < Int(period) / 2 {// || qNr > 3.0/4.0*period {
                    return -frequencyValue + 2 * frequencyValue * Double(currentSample % Int(period)) / (period/2) //2 * amplitude(currentSample) * Double(currentSample % Int(period)) / (period/4) - amplitude(currentSample)
                } else {
                    return frequencyValue
                         - 2 * frequencyValue * Double(currentSample % Int(period/2)) / (period/2)
                     //return amplitude(currentSample) - 2 * amplitude(currentSample) * Double(currentSample % Int(period)) / (period/4)
                     //z = -Double(currentSample % Int(x))/x
                }
            }*/
        case 3:
            audioUnit.currentWave.frequencySignal = Sawtooth(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
        case 5:
            audioUnit.currentWave.frequencySignal = NoiseWave(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
        default:
            break
        }
        } else {
            switch sender.selectedSegment {
            case 0:
                audioUnit.currentWave.amplitudeSignal = Sinusoid(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
            case 1:
                audioUnit.currentWave.amplitudeSignal = Square(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100, dutyCycleShare: { _ in 0.5 })
            case 2:
                audioUnit.currentWave.amplitudeSignal = Triangular(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
            case 3:
                audioUnit.currentWave.amplitudeSignal = Sawtooth(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
            case 5:
                audioUnit.currentWave.amplitudeSignal = NoiseWave(frequency: { currentSample in frequencyValue }, amplitude: { currentSample in amplitudeValue }, initialPhase: { _ in 0}, sampleRate: 44100)
            default:
                break
            }
        }
        //updateValues()
    }
    
    
    @objc func onAmplitudeModulationKindChanged(_ sender: NSSegmentedControl) {
        let frequencyValue = self.frequencyInput.doubleValue
        let amplitudeValue = self.amplitudeInput.doubleValue
        switch sender.selectedSegment {
        case 0:
            audioUnit.currentWave.frequency = { currentSample in
                return frequencyValue * sin(Double(currentSample)*Double.pi/2)
            }
            /*audioUnit.channels[audioUnit.selectedChannel] = Sinusoid(
                frequency: audioUnit.channels[audioUnit.selectedChannel].frequency,
                amplitude: audioUnit.channels[audioUnit.selectedChannel].amplitude,
                initialPhase: audioUnit.channels[audioUnit.selectedChannel].initialPhase, sampleRate: audioUnit.sampleRate)*/
        case 1:
            audioUnit.currentWave.frequency = { currentSample in
                let period = Int(currentSample / 400)
                return frequencyValue * Double((0-1) * (period % 2) + ((period % 2) - 1))
            }
            /*audioUnit.channels[audioUnit.selectedChannel] = Square(
                frequency: audioUnit.channels[audioUnit.selectedChannel].frequency,
                amplitude: audioUnit.channels[audioUnit.selectedChannel].amplitude,
                initialPhase: 0,
                sampleRate: audioUnit.sampleRate,
                dutyCycleShare: { _ in 0.5 })
            //add dutyCycle label*/
        /*case 2:
            audioUnit.type = .triangle
        case 3:
            audioUnit.type = .sawtooth
        case 5:
            audioUnit.type = .noise*/
        default:
            break
        }
        
        updateValues()
    }
    
    func layoutSubviews() {
        let labelWidth: CGFloat = 50
        let inputWidth: CGFloat = 50
        let labelHeight: CGFloat = 20
        let inputHeight = labelHeight
        signalKindSwitch.translatesAutoresizingMaskIntoConstraints = false
        signalKindSwitch.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        signalKindSwitch.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        
        frequencyModulationKindSwitch.translatesAutoresizingMaskIntoConstraints = false
        frequencyModulationKindSwitch.topAnchor.constraint(equalTo: signalKindSwitch.bottomAnchor, constant: 12).isActive = true
        frequencyModulationKindSwitch.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        amplitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        amplitudeInput.translatesAutoresizingMaskIntoConstraints = false
        amplitudeLabel.topAnchor.constraint(equalTo: frequencyModulationKindSwitch.bottomAnchor, constant: 12).isActive = true
        amplitudeLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        amplitudeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        amplitudeLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        amplitudeLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        amplitudeInput.heightAnchor.constraint(equalToConstant: inputHeight).isActive = true
        amplitudeInput.leftAnchor.constraint(equalTo: amplitudeLabel.rightAnchor, constant: 4).isActive = true
        amplitudeInput.centerYAnchor.constraint(equalTo: amplitudeLabel.centerYAnchor, constant: 0).isActive = true
        amplitudeInput.widthAnchor.constraint(equalToConstant: inputWidth).isActive = true
        
        amplitudeSlider.translatesAutoresizingMaskIntoConstraints = false
        amplitudeSlider.leftAnchor.constraint(equalTo: amplitudeInput.rightAnchor, constant: 8).isActive = true
        amplitudeSlider.centerYAnchor.constraint(equalTo: amplitudeLabel.centerYAnchor, constant: 0).isActive = true
        
        phaseLabel.translatesAutoresizingMaskIntoConstraints = false
        phaseInput.translatesAutoresizingMaskIntoConstraints = false
        phaseLabel.topAnchor.constraint(equalTo: amplitudeLabel.bottomAnchor, constant: 12).isActive = true
        phaseLabel.leftAnchor.constraint(equalTo: amplitudeLabel.leftAnchor, constant: 0).isActive = true
        phaseLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        phaseLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        phaseInput.heightAnchor.constraint(equalToConstant: inputHeight).isActive = true
        phaseInput.leftAnchor.constraint(equalTo: phaseLabel.rightAnchor, constant: 4).isActive = true
        phaseInput.centerYAnchor.constraint(equalTo: phaseLabel.centerYAnchor, constant: 0).isActive = true
        phaseInput.widthAnchor.constraint(equalToConstant: inputWidth).isActive = true
        
        phaseSlider.translatesAutoresizingMaskIntoConstraints = false
        phaseSlider.leftAnchor.constraint(equalTo: phaseInput.rightAnchor, constant: 8).isActive = true
        phaseSlider.centerYAnchor.constraint(equalTo: phaseLabel.centerYAnchor, constant: 0).isActive = true
        
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        frequencyInput.translatesAutoresizingMaskIntoConstraints = false
        frequencyLabel.topAnchor.constraint(equalTo: phaseLabel.bottomAnchor, constant: 12).isActive = true
        frequencyLabel.leftAnchor.constraint(equalTo: phaseLabel.leftAnchor, constant: 0).isActive = true
        frequencyLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        frequencyLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        frequencyInput.heightAnchor.constraint(equalToConstant: inputHeight).isActive = true
        frequencyInput.leftAnchor.constraint(equalTo: frequencyLabel.rightAnchor, constant: 4).isActive = true
        frequencyInput.centerYAnchor.constraint(equalTo: frequencyLabel.centerYAnchor, constant: 0).isActive = true
        frequencyInput.widthAnchor.constraint(equalToConstant: inputWidth).isActive = true
        
        frequencySlider.translatesAutoresizingMaskIntoConstraints = false
        frequencySlider.leftAnchor.constraint(equalTo: frequencyInput.rightAnchor, constant: 8).isActive = true
        frequencySlider.centerYAnchor.constraint(equalTo: frequencyLabel.centerYAnchor, constant: 0).isActive = true

        channelsList.translatesAutoresizingMaskIntoConstraints = false
        channelsList.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        //modulationLabel.
        
        //drawView.leftAnchor.constraint(equalTo: self.le, constant: <#T##CGFloat#>)
        
    }

    func setupSubviews() {
        
        self.phaseInput.delegate = self
        
        self.amplitudeInput.delegate = self
        self.frequencyInput.delegate = self
        //self.view.fill(with: drawView, inset: 0)
        self.view.addSubview(drawView)
        self.view.addSubview(signalKindSwitch)
        self.view.addSubview(frequencyModulationKindSwitch)
        signalKindSwitch.selectedSegment = 0
        self.view.addSubview(self.channelsList)
        channelsList.addItems(withTitles: ["New"])
        
        amplitudeLabel.stringValue = "A:"
        self.view.addSubview(amplitudeLabel)
        self.view.addSubview(amplitudeInput)
        self.view.addSubview(amplitudeSlider)
        amplitudeSlider.minValue = 0
        amplitudeSlider.maxValue = 40000
        amplitudeSlider.widthAnchor.constraint(equalToConstant: 200).isActive = true
        phaseLabel.stringValue = "Phase:"
        self.view.addSubview(phaseLabel)
        self.view.addSubview(phaseInput)
        self.view.addSubview(phaseSlider)
        phaseSlider.minValue = 0
        phaseSlider.maxValue = 40000
        phaseSlider.widthAnchor.constraint(equalTo: amplitudeSlider.widthAnchor, multiplier: 1.0).isActive = true
        
        frequencyLabel.stringValue = "f:"
        self.view.addSubview(frequencyLabel)
        self.view.addSubview(frequencyInput)
        self.view.addSubview(frequencySlider)
        frequencySlider.minValue = 0
        frequencySlider.maxValue = 16000
        frequencySlider.widthAnchor.constraint(equalTo: amplitudeSlider.widthAnchor, multiplier: 1.0).isActive = true
        let btnPlay = NSButton(title: "Play", target: self, action: #selector(btnPlayTapped(_:)))
        self.view.addSubview(btnPlay)
        btnPlay.translatesAutoresizingMaskIntoConstraints = false
        btnPlay.centerXAnchor.constraint(equalTo: frequencyLabel.centerXAnchor, constant: 0).isActive = true
        btnPlay.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: 8).isActive = true
        
        let btnStop = NSButton(title: "Stop", target: self, action: #selector(btnStopTapped(_:)))
         self.view.addSubview(btnStop)
         btnStop.translatesAutoresizingMaskIntoConstraints = false
         btnStop.leftAnchor.constraint(equalTo: btnPlay.rightAnchor, constant: 12).isActive = true
         btnStop.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: 8).isActive = true
        
        let btnPlayAll = NSButton(title: "Play All", target: self, action: #selector(btnPlayAllTapped(_:)))
         self.view.addSubview(btnPlayAll)
         btnPlayAll.translatesAutoresizingMaskIntoConstraints = false
         btnPlayAll.centerXAnchor.constraint(equalTo: frequencyLabel.centerXAnchor, constant: 0).isActive = true
         btnPlayAll.topAnchor.constraint(equalTo: btnPlay.bottomAnchor, constant: 8).isActive = true
         
         let btnStopAll = NSButton(title: "Pause", target: self, action: #selector(btnPauseTapped(_:)))
          self.view.addSubview(btnStopAll)
          btnStopAll.translatesAutoresizingMaskIntoConstraints = false
          btnStopAll.leftAnchor.constraint(equalTo: btnPlay.rightAnchor, constant: 12).isActive = true
          btnStopAll.topAnchor.constraint(equalTo: btnPlay.bottomAnchor, constant: 8).isActive = true
        let subview = drawView
        //self.view.addSubview(subview)
        let inset: CGFloat = 8
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.widthAnchor.constraint(greaterThanOrEqualToConstant: 400).isActive = true
        subview.topAnchor.constraint(equalTo: self.frequencyModulationKindSwitch.bottomAnchor, constant: inset).isActive = true
        subview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -inset).isActive = true
        subview.leftAnchor.constraint(equalTo: self.amplitudeSlider.rightAnchor, constant: inset).isActive = true
        subview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -inset).isActive = true
        
        self.view.addSubview(btnPlayMusic)
        //btnPlayMusic.backgroundFilters = btnPlay.backgroundFilters
        btnPlayMusic.wantsLayer = true
        //btnPlayMusic.layer?.backgroundColor = NSColor.white.cgColor
        btnPlayMusic.attributedTitle = NSAttributedString(string: "Play Me", attributes: [NSAttributedString.Key.foregroundColor: NSColor.red, NSAttributedString.Key.backgroundColor: NSColor.white ])
        btnPlayMusic.topAnchor.constraint(equalTo: btnPlayAll.bottomAnchor, constant: 8).isActive = true
        btnPlayMusic.translatesAutoresizingMaskIntoConstraints = false
        btnPlayMusic.centerXAnchor.constraint(equalTo: btnPlay.centerXAnchor, constant: 0).isActive = true
        btnPlayMusic.action = #selector(self.btnPlayMusicTapped(_:))
        btnPlayMusic.bezelStyle = .rounded
        drawView.wantsLayer = true
        drawView.layer?.cornerRadius = 20
        //Move:
        self.view.addSubview(self.paramsVarChangeSwitch)
        paramsVarChangeSwitch.translatesAutoresizingMaskIntoConstraints = false
        paramsVarChangeSwitch.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        paramsVarChangeSwitch.bottomAnchor.constraint(equalTo: self.amplitudeInput.topAnchor, constant: -12).isActive = true
        paramsVarChangeSwitch.selectedSegment = 0
    }
    
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
        /*var seconds: Double = 0
        let melodySpeed: Double = 60/60 //quorters per minute
        var sheetMusicIndex = 0
        var beginningSecond: Double = 0
        var delta = 1
        let relation = 1/KeyLength.fourth.rawValue
        let fadeTime: Double = 3*/
        var frequency: (_: Int) -> Double
        
        if keyIndex == 0 {
            frequency = { currentSample in
                let second: Double = Double(currentSample)/44100
                if abs(second - (Double(params.beginningSecond) + melody[params.sheetMusicIndex].length.rawValue*params.melodySpeed * params.relation)) < 0.001 {
                    params.beginningSecond = second
                    if params.sheetMusicIndex == melody.count-1 && params.delta == 1 || params.sheetMusicIndex == 0 && params.delta == -1 {
                        //params.delta = -params.delta
                        params.sheetMusicIndex = 16
                        params.beginningSecond = 0
                        self.audioUnit.renderer?.waves[0].coords = .init()
                        self.audioUnit.currentSample = 0
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
        switch self.signalKindSwitch.selectedSegment {
        case 1:
            return Square.init(
                frequency: frequency,
                amplitude: { currentSample in
                    let second: Double = Double(currentSample)/44100
                    var amplitude: Double = 10000*melody[params.sheetMusicIndex].velocity// * key.force
                    if abs(second - Double(params.beginningSecond)) < 0.001 {
                        //amplitude = amplitude
                    } else {
                        amplitude = max(amplitude - amplitude * (second - params.beginningSecond)/params.fadeTime, 0)
                    }
                    return amplitude
            },
                initialPhase: { _ in return 0},
                sampleRate: 44100, dutyCycleShare: { _ in return 0.5 })
        default:
            return Sinusoid.init(
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
                sampleRate: 44100)
            
        }
         
    }
    
    func getMelodyWaveRightHand(for keyIndex: Int, params: MelodyWaveParams) -> AudioWave {
        var frequency: (_: Int) -> Double
        let baseAmplitude: Double = 20000
        if keyIndex == 0 {
            frequency = { currentSample in
                let second: Double = Double(currentSample)/44100
                if abs(second - (Double(params.beginningSecond) + melodyRightHand[params.sheetMusicIndex].length.rawValue*params.melodySpeed * params.relation)) < 0.001 {
                    params.beginningSecond = second
                    if params.sheetMusicIndex == melodyRightHand.count-1 && params.delta == 1 || params.sheetMusicIndex == 0 && params.delta == -1 {
                        //params.delta = -params.delta
                        //params.sheetMusicIndex = 16
                        params.sheetMusicIndex = 0
                        params.beginningSecond = 0
                        //self.audioUnit.renderer?.waves[0].coords = .init()
                        //self.audioUnit.currentSample = 0
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
        switch self.signalKindSwitch.selectedSegment {
        case 1:
            return Square.init(
                frequency: frequency,
                amplitude: { currentSample in
                    let second: Double = Double(currentSample)/44100
                    var amplitude: Double = baseAmplitude * melodyRightHand[params.sheetMusicIndex].velocity// * key.force
                    if abs(second - Double(params.beginningSecond)) < 0.001 {
                        //amplitude = 10000
                    } else {
                        amplitude = max(amplitude - amplitude * (second - params.beginningSecond)/params.fadeTime, 0)
                    }
                    return amplitude
            },
                initialPhase: { _ in return 0},
                sampleRate: 44100, dutyCycleShare: { _ in return 0.5 })
        default:
            return Sinusoid.init(
                frequency: frequency,
                amplitude: { currentSample in
                    let second: Double = Double(currentSample)/44100
                    var amplitude: Double = baseAmplitude * melodyRightHand[params.sheetMusicIndex].velocity// * key.force
                    if abs(second - Double(params.beginningSecond)) < 0.001 {
                        amplitude = baseAmplitude * melodyRightHand[params.sheetMusicIndex].velocity
                    } else {
                        amplitude = max(baseAmplitude * melodyRightHand[params.sheetMusicIndex].velocity - baseAmplitude * melodyRightHand[params.sheetMusicIndex].velocity * (second - params.beginningSecond)/params.fadeTime, 0)
                    }
                    return amplitude
            },
                initialPhase: { _ in return 0},
                sampleRate: 44100)
        }
         
    }

    
    @objc func btnPlayMusicTapped(_ sender: NSButton) {
        self.audioUnit.channels = [AudioWave]()
        self.audioUnit.renderer?.waves = [WaveVisualization]()
        
        let params = MelodyWaveParams()
        
        self.audioUnit.channels.append(getMelodyWave(for: 0, params: params))
        self.audioUnit.channels.append(getMelodyWave(for: 1, params: params))
        self.audioUnit.channels.append(getMelodyWave(for: 2, params: params))
        self.audioUnit.channels.append(getMelodyWave(for: 3, params: params))

        let rightParams = MelodyWaveParams()
        self.audioUnit.channels.append(getMelodyWaveRightHand(for: 0, params: rightParams))
        self.audioUnit.channels.append(getMelodyWaveRightHand(for: 1, params: rightParams))

        //self.audioUnit.renderer?.waves.append(.init(coords: [CGPoint](), color: NSColor.red.cgColor))
        audioUnit.currentSample = 0
        audioUnit.enableSpeaker()
        self.updateValues()
    }
    
    func updateSound() {
        DispatchQueue.main.async {
            let amplitude = self.amplitudeInput.doubleValue
            let frequency = self.frequencyInput.doubleValue
            let phase = self.phaseInput.doubleValue
        /*audioUnit.setFrequency(freq: Double(self.frequencyInput.stringValue) ?? 0)
        audioUnit.setPhase(phase: Double(self.phaseInput.stringValue) ?? 0)
        audioUnit.sampleRate = 44100
        audioUnit.setAmplitude(amplitude: Double(self.amplitudeInput.stringValue) ?? 0)
        audioUnit.setToneTime(t: 100)*/
            self.audioUnit.currentWave.frequency = { _ in frequency }// setFrequency(freq: Double(self.frequencyInput.stringValue) ?? 0)
            //audioUnit//.setPhase(phase: Double(self.phaseInput.stringValue) ?? 0)
            self.audioUnit.currentWave.initialPhase = { _ in phase }
            self.audioUnit.sampleRate = 44100
            self.audioUnit.currentWave.amplitude = { _ in amplitude } //.setAmplitude(amplitude: Double(self.amplitudeInput.stringValue) ?? 0)
            self.audioUnit.setToneTime(t: 100)
        //if isPlaying {
        //    audioUnit.enableSpeaker()
        //}
        }
    }
    
    @objc func btnPlayTapped(_ sender: NSButton) {
        isPlaying = true//!isPlaying
        if isPlaying || true {
            /*audioUnit.setFrequency(freq: Double(self.frequencyInput.stringValue) ?? 0)
            audioUnit.setPhase(phase: Double(self.phaseInput.stringValue) ?? 0)
            audioUnit.sampleRate = 44100
            audioUnit.setAmplitude(amplitude: Double(self.amplitudeInput.stringValue) ?? 0)
            audioUnit.enableSpeaker()
            audioUnit.setToneTime(t: 100)*/
            DispatchQueue.main.async {

                //let amplitude = Double(self.amplitudeInput.stringValue) ?? 0
                //let frequency = Double(self.frequencyInput.stringValue) ?? 0
                
                //self.audioUnit.channels[self.selectedChannel].frequency = { _ in frequency }// setFrequency(freq: Double(self.frequencyInput.stringValue) ?? 0)
                //audioUnit//.setPhase(phase: Double(self.phaseInput.stringValue) ?? 0)
                self.audioUnit.sampleRate = 44100
                //self.audioUnit.channels[self.selectedChannel].amplitude = { _ in amplitude } //.setAmplitude(amplitude: Double(self.amplitudeInput.stringValue) ?? 0)
                self.audioUnit.currentSample = 0
                self.audioUnit.currentWave.isPlaying = true
                self.audioUnit.enableSpeaker()
                self.audioUnit.setToneTime(t: 100)
            }
        } else {
            self.audioUnit.stop()
        }
    }
    
    @objc func btnPlayAllTapped(_ sender: NSButton) {
        isPlaying = true//!isPlaying
        if isPlaying || true {
            /*audioUnit.setFrequency(freq: Double(self.frequencyInput.stringValue) ?? 0)
            audioUnit.setPhase(phase: Double(self.phaseInput.stringValue) ?? 0)
            audioUnit.sampleRate = 44100
            audioUnit.setAmplitude(amplitude: Double(self.amplitudeInput.stringValue) ?? 0)
            audioUnit.enableSpeaker()
            audioUnit.setToneTime(t: 100)*/
            self.audioUnit.channels.forEach({ $0.isPlaying = true })
            self.audioUnit.enableSpeaker()
            self.audioUnit.setToneTime(t: 100)
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
            self.audioUnit.stop()
        }
    }
    
    @objc func btnStopTapped(_ sender: NSButton) {
        //self.audioUnit.currentChannel.isPlaying = false
        self.audioUnit.stop()
        self.isPlaying = self.audioUnit.audioRunning
    }
    
    @objc func btnPauseTapped(_ sender: NSButton) {
        audioUnit.pause()
        isPlaying = false
    }
    
    @objc func btnGenerateAndPlayTapped(_ sender: NSButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.view.addSubview(drawView)
        drawView.translatesAutoresizingMaskIntoConstraints = false
        drawView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        drawView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        drawView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        drawView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true*/
        self.setupSubviews()
        self.layoutSubviews()
        
        audioUnit.channels.append(Sinusoid(
            frequency: { _ in Double(self.frequencyInput.stringValue) ?? 0 },
            amplitude: { _ in Double(self.amplitudeInput.stringValue) ?? 0 },
            initialPhase: { _ in Double(self.phaseInput.stringValue) ?? 0 }, sampleRate: 44100))
        audioUnit.renderer = self.renderer
        //audioUnit.renderer?.waves.append(.init(coords: [CGPoint](), color: NSColor.red.cgColor))
        audioUnit.viewDelegate = self.drawView
        self.drawView.renderer = self.renderer
        
        self.channelsList.insertItem(withTitle: "Channel 1 (Sinusoid)", at: 0)
        self.channelsList.selectItem(at: 0)
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    override func mouseDown(with event: NSEvent) {
        self.drawView.setNeedsDisplay(self.drawView.visibleRect)
    }
    
    override func mouseUp(with event: NSEvent) {
        //Page.main.onMouseUp(at: location)
        self.drawView.setNeedsDisplay(self.drawView.visibleRect)
    }
}
/*
class Figure {
    var logRect: CGRect
    var fillColor: CGColor = NSColor.blue.cgColor
    
    func draw(to context: CGContext) {
        context.addRect(self.logRect)
        context.setFillColor(self.fillColor)
        context.fillPath()
    }
    
    init(logRect: CGRect) {
        self.logRect = logRect
    }
}

class Page {
    static var main = Page.init()
    var figures = [Figure]()
    func render(to context: CGContext) {
        figures.forEach({
            $0.draw(to: context)
        })
    }
    
    func onMouseDown(at point: CGPoint) {
        
    }
    
    func onMouseUp(at point: CGPoint) {
        figures.append(.init(logRect: .init(x: point.x - 50, y: point.y - 25, width: 100, height: 50)))
    }
}

*/

final class ToneOutputUnit: NSObject {

    var auAudioUnit: AUAudioUnit! = nil     // placeholder for RemoteIO Audio Unit
    var type: GenerationType = .sinusoid
    var avActive     = false             // AVAudioSession active flag
    var audioRunning = false             // RemoteIO Audio Unit running flag

    var sampleRate : Double = 44100.0    // typical audio sample rate

    var frequency  =    880.0              // default frequency of tone:   'A' above Concert A
    var amplitude  =  16383.0              // default volume of tone:      half full scale

    var toneCount : Int32 = 0       // number of samples of tone to play.  0 for silence

    var dutyCycle: Double = 0.5

    private var phY = 0.0       // save phase of sine wave to prevent clicking
    private var interrupted = false     // for restart from audio interruption notification

    func setPhase(phase: Double) {
        self.phY = phase
    }
    
    func setFrequency(freq : Double) {  // audio frequencies below 500 Hz may be
        self.frequency = freq                       //   hard to hear from a tiny iPhone speaker.
    }

    func setToneVolume(vol : Double) {  // 0.0 to 1.0
        self.amplitude = vol * 32766.0
    }
    func setAmplitude(amplitude: Double) {
        self.amplitude = amplitude
    }

    func setToneTime(t: Double) {
        toneCount = Int32(t * sampleRate);
    }
    func set(N: Double) {
        self.sampleRate = N
    }
    //func set(n: Double) {
    //    self.sampleRate = n
    //}

    func enableSpeaker() {

        if audioRunning {

            print("returned")
            return

        }           // return if RemoteIO is already running



        do {        // not running, so start hardware
            currentSample = 0
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

    // helper functions
//
    /*func sinusoid(mBuffers: AudioBuffer, count: Int, d: Double, xn: inout Double, sz: Int) {
        let bufferPointer = UnsafeMutableRawPointer(mBuffers.mData)
        if var bptr = bufferPointer {
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
            }
        }
    }
    
    */
    
    var currentSample: Int = 0
    private func fillSpeakerBuffer(     // process RemoteIO Buffer for output
        inputDataList : UnsafeMutablePointer<AudioBufferList>, frameCount : UInt32 ) {
        let inputDataPtr = UnsafeMutableAudioBufferListPointer(inputDataList)
        let nBuffers = inputDataPtr.count
        if (nBuffers > 0) {

            let mBuffers: AudioBuffer = inputDataPtr[0]
            let count = Int(frameCount)

            // Speaker Output == play tone at frequency f0
            if (self.amplitude > 0)
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
                            currentSample = currentSample + 1//)%Int(self.sampleRate)
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
            }
        }
    }



    func stop() {
        if (audioRunning) {
            auAudioUnit.stopHardware()
            audioRunning = false
        }
    }
}

protocol Renderable {
    func render(to: CGContext)
}


extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            //if textView === self.frequencyInput {
            let frequency = self.frequencyInput.doubleValue
            let amplitude = self.amplitudeInput.doubleValue
            switch self.currentVars {
            case .signal:
                    audioUnit.currentWave.frequency = { _ in
                        return frequency
                    }
            case .frequency:
                self.frequencyFrequencyModulation = frequency / 1000
                self.audioUnit.currentWave.frequencySignal?.frequency = { _ in frequency / 1000 }
            case .amplitude:
                self.frequencyAmplitudeModulation = frequency / 1000
                self.audioUnit.currentWave.amplitudeSignal?.frequency = { _ in frequency / 1000}
            //
            }
            
            //let amplitude = self.amplitudeInput.doubleValue
            switch self.currentVars {
            case .signal:
                    audioUnit.currentWave.amplitude = { _ in
                        return amplitude
                    }
            case .frequency:
                self.amplitudeFrequencyModulation = amplitude / 1000
                audioUnit.currentWave.frequencySignal?.amplitude = { _ in amplitude / 1000 }
            case .amplitude:
                self.amplitudeAmplitudeModulation = amplitude / 1000
                audioUnit.currentWave.amplitudeSignal?.amplitude = { _ in amplitude / 1000 }
            //
            }
            return true
        } else if (commandSelector == #selector(NSResponder.deleteForward(_:))) {
            // Do something against DELETE key
            return false
        } else if (commandSelector == #selector(NSResponder.deleteBackward(_:))) {
            // Do something against BACKSPACE key
            return false
        } else if (commandSelector == #selector(NSResponder.insertTab(_:))) {
            // Do something against TAB key
            return false
        } else if (commandSelector == #selector(NSResponder.cancelOperation(_:))) {
            // Do something against ESCAPE key
            return false
        }

        // return true if the action was handled; otherwise false
        return false
    }
}
