//
//  KeyLength.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

indirect enum KeyLength: Double {
    case half = 0.5
    case fourth = 0.25
    case eigth = 0.125
    case sixteenth = 0.0625
    
    case halfExtended = 0.75
    case fourthExtended = 0.375
    case eigthExtended = 0.1875
    case sixteenthExtended = 0.09375
    //case extended(length: KeyLength)
    var extended: KeyLength {
        //return KeyLength(rawValue: self.rawValue * 1.5) ?? KeyLength.half
        switch self {
        case .half:
            return .halfExtended
        case .fourth:
            return .fourthExtended
        case .eigth:
            return .eigthExtended
        case .sixteenth:
            return .sixteenthExtended
        default:
            return .half
        }
    }
}
