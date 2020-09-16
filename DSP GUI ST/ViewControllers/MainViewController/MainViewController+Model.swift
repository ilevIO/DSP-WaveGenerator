//
//  MainViewController+Model.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/16/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

extension MainViewController {
    class Model {
        var audioUnit = Mixer()
        var controller: Controller?
        func addSignal(type: GenerationType) {
            let params = controller?.staticParams ?? Params.standard
            switch type {
             case .sinusoid:
                 audioUnit.channels.append(Sinusoid(params: params))
             case .square:
                 audioUnit.channels.append(Square(params: params))
             case .triangle:
                 audioUnit.channels.append(Triangular(params: params))
             case .sawtooth:
                 audioUnit.channels.append(Sawtooth(params: params))
             case .noise:
                 audioUnit.channels.append(NoiseWave(params: params))
             audioUnit.selectedWave = audioUnit.channels.count - 1
            }
        }
        
        func selectWave(at index: Int) {
            audioUnit.selectedWave = index
        }
    }
}
