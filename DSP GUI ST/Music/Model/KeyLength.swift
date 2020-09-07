//
//  KeyLength.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

enum KeyLength: Double {
    case half = 0.5
    case fourth = 0.25
    case eigth = 0.125
    case sixteenth = 0.065
    var extended: KeyLength {
        return KeyLength(rawValue: self.rawValue * 1.5) ?? self
    }
}
