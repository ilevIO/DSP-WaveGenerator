//
//  SheetNote.swift
//  DSP GUI ST
//
//  Created by ilyayelagov on 9/7/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

struct SheetNote {
    var notes: [Key]
    var length: KeyLength
    var sustain: Bool = false
    var velocity: Double = 1
}
