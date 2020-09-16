//
//  Key.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

struct Key {
    var note: Note
    var octave: Int
    var frequency: Double {
        var value: Double = 0
        value = self.note.rawValue
        var octave = self.octave
        while octave > 0 {
            value *= 2
            octave -= 1
        }
        return value
    }
    init(_ note: Note, _ octave: Int) {
        self.note = note
        self.octave = octave
    }
}
