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

class MainViewController: NSViewController {
    
    var controller: Controller!
    
    @objc func onParamsChange(_ sender: NSSegmentedControl) {
        controller.variableParamsChanged(to: sender.selectedSegment)
        self.updateValues()
        
    }
    //MARK: -subviews
    var drawView = WavesDrawView()
    var amplitudeInput = NSTextField()
    var phaseInput = NSTextField()
    var frequencyInput = NSTextField()
    var amplitudeLabel = Label()
    var phaseLabel = Label()
    var frequencyLabel = Label()
    var modulationLabel = Label()
    var btnNoneModulation = NSButton(title: "None", target: self, action: #selector(btnNoneTapped(_:)))
    var btnPlayMusic = NSButton()
    //MARK: -control
    var channelsList = NSPopUpButton(title: "Channels", target: nil, action: #selector(onChannelChanged(_:)))
    let signalKindSwitch = NSSegmentedControl(labels: ["Sinusoid", "Square", "Triangle", "Sawtooth", "Noise"], trackingMode: .selectOne, target: nil, action: #selector(onKindChanged(_:)))
    let paramsVarChangeSwitch = NSSegmentedControl(labels: [Controller.ParamsVariation.signal.rawValue, Controller.ParamsVariation.frequency.rawValue, Controller.ParamsVariation.amplitude.rawValue], trackingMode: .selectOne, target: nil, action: #selector(onParamsChange(_:)))
    
    var amplitudeSlider: NSSlider = NSSlider(target: nil, action: #selector(amplitudeSliderChanged(_:)))
    var phaseSlider: NSSlider = NSSlider(target: nil, action: #selector(phaseSliderChanged(_:)))
    var frequencySlider: NSSlider = NSSlider(target: nil, action: #selector(frequencySliderChanged(_:)))
    
    @objc func btnNoneTapped(_ sender: NSButton) {
        controller.clearSignal()
        self.updateValues()
    }
    
    @objc func onChannelChanged(_ sender: NSPopUpButton) {
        let index = sender.indexOfSelectedItem
        
        if index == sender.numberOfItems - 1 {
            controller.createNewChannel()
        } else {
            controller.channelChanged(to: index)
        }

    }
    
    private func updateUiComponents(for signal: AudioWave?, floating: Int = 0) {
        
        self.frequencySlider.doubleValue = signal?.frequency(0) ?? 0
        self.amplitudeSlider.doubleValue = signal?.amplitude(0) ?? 0
        
        self.frequencyInput.stringValue = String(format: "%.\(floating)f", signal?.frequency(0) ?? 0)
        self.amplitudeInput.stringValue = String(format: "%.\(floating)f", signal?.amplitude(0) ?? 0)
        
        if let signal = signal {
            switch signal.getType() {
            case .sinusoid:
                self.signalKindSwitch.selectedSegment = 0
            case .square:
                self.signalKindSwitch.selectedSegment = 1
            case .triangle:
                self.signalKindSwitch.selectedSegment = 2
            case .sawtooth:
                self.signalKindSwitch.selectedSegment = 3
            case .noise:
                self.signalKindSwitch.selectedSegment = 4
            }
        } else {
            self.signalKindSwitch.setSelected(false, forSegment: self.signalKindSwitch.selectedSegment)
        }

    }
    
    func updateValues() {
        self.channelsList.removeAllItems()
        
        for channelTitle in controller.getChannelsTitle() {
            self.channelsList.addItem(withTitle: channelTitle)
        }
        self.channelsList.addItem(withTitle: "New...")
        
        controller.isSettingChannelSelection = true
        self.channelsList.selectItem(at: controller.selectedChannel)
        controller.isSettingChannelSelection = false
        
        let amplitudeRange = controller.getAmplitudeRange()
        let frequencyRange = controller.getFrequencyRange()
        let signal = controller.getSignal()
        
        amplitudeSlider.minValue = amplitudeRange.lowerBound
        amplitudeSlider.maxValue = amplitudeRange.upperBound
        frequencySlider.minValue = frequencyRange.lowerBound
        frequencySlider.maxValue = frequencyRange.upperBound
        let requiredPrecision: Int = controller.getRequiredPrecision()
        updateUiComponents(for: signal, floating: requiredPrecision)
    }
    
    @objc func amplitudeSliderChanged(_ sender: NSSlider) {
        let amplitudeValue = self.amplitudeSlider.doubleValue
        controller.amplitudeValueChanged(to: amplitudeValue)
        amplitudeInput.stringValue = String(format: "%.\(controller.getRequiredPrecision())f", amplitudeValue)
    }
    
    @objc func phaseSliderChanged(_ sender: NSSlider) {
        let phaseValue = self.phaseSlider.doubleValue
        controller.phaseValueChanged(to: phaseValue)
        phaseInput.stringValue = String(format: "%.\(controller.getRequiredPrecision())f", phaseValue)
    }
    
    @objc func frequencySliderChanged(_ sender: NSSlider) {
        let frequencyValue = self.frequencySlider.doubleValue
        controller.frequencyValueChanged(to: frequencyValue)
        frequencyInput.stringValue = String(format: "%.\(controller.getRequiredPrecision())f", frequencyValue)
    }
    
    @objc func onKindChanged(_ sender: NSSegmentedControl) {
        controller.modulationKindChanged(to: sender.selectedSegment)
    }
    
    func layoutSubviews() {
        let labelWidth: CGFloat = 50
        let inputWidth: CGFloat = 50
        let labelHeight: CGFloat = 20
        let inputHeight = labelHeight
        signalKindSwitch.translatesAutoresizingMaskIntoConstraints = false
        signalKindSwitch.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        signalKindSwitch.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        amplitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        amplitudeInput.translatesAutoresizingMaskIntoConstraints = false
        amplitudeLabel.topAnchor.constraint(equalTo: signalKindSwitch.bottomAnchor, constant: 12).isActive = true
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
    }

    func setupSubviews() {
        
        self.phaseInput.delegate = self
        
        self.amplitudeInput.delegate = self
        self.frequencyInput.delegate = self
        //self.view.fill(with: drawView, inset: 0)
        self.view.addSubview(drawView)
        self.view.addSubview(signalKindSwitch)
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
        subview.topAnchor.constraint(equalTo: self.signalKindSwitch.bottomAnchor, constant: inset).isActive = true
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
    

    
    @objc func btnPlayMusicTapped(_ sender: NSButton) {
        controller.playMusic()
        self.updateValues()
    }
    
    
    @objc func btnPlayTapped(_ sender: NSButton) {
        controller.playTone()
    }
    
    @objc func btnPlayAllTapped(_ sender: NSButton) {
        controller.playAll()
    }
    
    @objc func btnStopTapped(_ sender: NSButton) {
        controller.stop()
    }
    
    @objc func btnPauseTapped(_ sender: NSButton) {
        controller.pause()
    }
    
    @objc func btnGenerateAndPlayTapped(_ sender: NSButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let renderer = WaveRenderer()
        self.controller = Controller(renderer: renderer)
        controller.view = self
        self.drawView.renderer = renderer
        
        self.setupSubviews()
        self.layoutSubviews()
        
        self.channelsList.insertItem(withTitle: "Channel 1 (Sinusoid)", at: 0)
        self.channelsList.selectItem(at: 0)
    }

    override var representedObject: Any? {
        didSet {
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

protocol Renderable {
    func render(to: CGContext)
}


extension MainViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            //if textView === self.frequencyInput {
            controller.valueEntered()
            self.updateValues()
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
