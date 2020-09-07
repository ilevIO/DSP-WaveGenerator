//
//  Keys.swift
//  DSP GUI ST
//
//  Created by Ilya Yelagov on 9/4/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

enum Note: Double {
    case A = 27.5
    case B = 30.868
    case C = 32.703
    case D = 36.701
    case E = 41.203
    case F = 43.654
    case G = 48.999

    case Asharp = 29.135
    case Csharp = 34.648
    case Dsharp = 38.891
    case Fsharp = 46.249
    case Gsharp = 51.913
}



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


