//
//  KeysManager.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

class KeysManager  {
    static func getFrequency(forKey key: Note, octave: Int) -> Double {
        var value: Double = 0
        value = key.rawValue
        var octave = octave
        while octave > 0 {
            value *= 2
            octave -= 1
        }
        return value
    }
}
