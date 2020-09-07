//
//  Keys.swift
//  DSP GUI ST
//
//  Created by Ilya Yelagov on 9/4/20.
//  Copyright © 2020 ilyayelagov. All rights reserved.
//

import Foundation

    //MARK: -RIGHT HAND
let melodyRightHand: [SheetNote] = [
    
    .init(notes: [.init(.D, 1), .init(.D, 2)], length: .eigth),
    .init(notes: [.init(.A, 1), .init(.A, 2)], length: .eigth),
    //MARK: -1
    .init(notes: [.init(.Asharp, 1), .init(.Asharp, 2)], length: .fourth),
    .init(notes: [.init(.D, 1), .init(.D, 2)], length: .fourth),
    //MARK: -2
    .init(notes: [.init(.F, 1), .init(.F, 2)], length: .fourth),
    .init(notes: [.init(.G, 1), .init(.G, 2)], length: .fourth),
    //MARK: -3
    .init(notes: [.init(.A, 2), .init(.A, 3)], length: .fourth),
    .init(notes: [.init(.A, 1), .init(.A, 2)], length: .fourth),
    //MARK: -4
    .init(notes: [.init(.D, 1), .init(.D, 2)], length: .fourth),
    .init(notes: [.init(.D, 1), .init(.D, 2)], length: .eigth),
    .init(notes: [.init(.D, 1), .init(.D, 2)], length: .eigth),
    
    //MARK: -line 2
    //MARK: -5
    .init(notes: [.init(.D, 1)], length: .fourth),
    .init(notes: [.init(.F, 1)], length: .fourth),
    
    //MARK: -6
    .init(notes: [.init(.G, 1)], length: .fourth),
    .init(notes: [.init(.Asharp, 2)], length: .fourth),
    //MARK: -7
    .init(notes: [.init(.A, 2)], length: .fourth),
    .init(notes: [.init(.A, 1)], length: .fourth),
    //MARK: -8
    .init(notes: [.init(.D, 1)], length: .eigth),
    .init(notes: [.init(.E, 1)], length: .eigth),
    .init(notes: [.init(.F, 1)], length: .eigth),
    .init(notes: [.init(.A, 2)], length: .eigth),
    //MARK: -9
    .init(notes: [.init(.C, 2)], length: .fourth),
    .init(notes: [.init(.Asharp, 2)], length: .fourth),
    //MARK: -10
    .init(notes: [.init(.A, 2)], length: .fourth),
    .init(notes: [.init(.F, 1)], length: .fourth),
    //MARK: -11
    .init(notes: [.init(.G, 1)], length: .fourth),
    .init(notes: [.init(.E, 1)], length: .fourth),
    //MARK: -12
    .init(notes: [.init(.A, 1)], length: .eigth),
    .init(notes: [.init(.Csharp, 1)], length: .eigth),
    .init(notes: [.init(.E, 1)], length: .eigth),
    .init(notes: [.init(.A, 2)], length: .eigth),

]
    //MARK: -LEFT HAND
let melody: [SheetNote] = [
    .init(notes: [.init(.D, 4), .init(.F, 4), .init(.A, 5)], length: .eigth),
    .init(notes: [.init(.E, 4), .init(.A, 5), .init(.C, 5)], length: .eigth),
    //MARK: -1
    .init(notes: [.init(.F, 4), .init(.Asharp, 5), .init(.D, 5)], length: KeyLength.eigth),
    .init(notes: [.init(.F, 4), .init(.Asharp, 5), .init(.D, 5)], length: KeyLength.sixteenth),
    .init(notes: [.init(.F, 4), .init(.Asharp, 5), .init(.D, 5)], length: KeyLength.sixteenth),
    .init(notes: [.init(.F, 4), .init(.Asharp, 5), .init(.D, 5)], length: KeyLength.eigth),
    .init(notes: [.init(.F, 4), .init(.Asharp, 5), .init(.D, 5)], length: KeyLength.eigth),
    //MARK: -2
    .init(notes: [.init(.F, 4), .init(.A, 5), .init(.C, 5)], length: KeyLength.fourth),
    .init(notes: [.init(.D, 4), .init(.G, 4), .init(.Asharp, 5)], length: KeyLength.fourth),
    //MARK: -3
    .init(notes: [.init(.D, 4), .init(.G, 4), .init(.A, 5)], length: KeyLength.fourth),
    .init(notes: [.init(.Csharp, 4), .init(.E, 4), .init(.A, 5)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.Csharp, 4), .init(.E, 4), .init(.A, 5)], length: KeyLength.sixteenth),
    //MARK: -4
    .init(notes: [.init(.D, 4), .init(.F, 4), .init(.A, 5), .init(.D, 5)], length: KeyLength.eigth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.sixteenth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.sixteenth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.eigth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.eigth),
    
    //MARK: -Line 2
    
    //MARK: -5
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.fourth.extended),
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.eigth),
    //MARK: -6
    .init(notes: [.init(.Asharp, 3), .init(.D, 3), .init(.G, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.F, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.Asharp, 3), .init(.D, 3), .init(.E, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.D, 3)], length: KeyLength.eigth),
    //MARK: -7
    .init(notes: [.init(.A, 3), .init(.D, 3), .init(.F, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.A, 3), .init(.Csharp, 3), .init(.F, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.E, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 3), .init(.Csharp, 3), .init(.G, 3)], length: KeyLength.sixteenth),
    //MARK: -8
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.eigth),
    //MARK: -9
    .init(notes: [.init(.E, 2), .init(.G, 2), .init(.C, 3)], length: KeyLength.fourth.extended),
    .init(notes: [.init(.E, 2), .init(.G, 2), .init(.C, 3)], length: KeyLength.eigth),
    //MARK: -10
    .init(notes: [.init(.F, 2), .init(.C, 3), .init(.F, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.A, 3), .init(.C, 3), .init(.F, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.E, 3)], length: KeyLength.eigth),
    //MARK: -11
    .init(notes: [.init(.Asharp, 2), .init(.D, 3), .init(.G, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.Asharp, 2), .init(.D, 3), .init(.G, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.F, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.Asharp, 2), .init(.D, 3), .init(.G, 3)], length: KeyLength.eigth),
    //MARK: -12
    .init(notes: [.init(.A, 3), .init(.Csharp, 3), .init(.E, 3), .init(.A, 4), /*R:*/.init(.A, 1)], length: KeyLength.eigth),
    .init(notes: [.init(.A, 3), .init(.A, 4),/*R*/ .init(.Csharp, 1)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 3), .init(.A, 4),/*R*/ .init(.Csharp, 1)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 3), .init(.A, 4),/*R*/ .init(.E, 1)], length: KeyLength.eigth),
    .init(notes: [.init(.A, 3), .init(.A, 4),/*R*/ .init(.A, 2)], length: KeyLength.eigth),
    
    //MARK: -Line 3
    
    //MARK: -13
    .init(notes: [.init(.A, 3), .init(.D, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.fourth.extended),
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.eigth),
    //MARK: -14
    .init(notes: [.init(.D, 3), .init(.A, 4), .init(.C, 4)], length: KeyLength.eigth),
    .init(notes: [.init(.G, 3), .init(.Asharp, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.eigth),
    .init(notes: [.init(.E, 3), .init(.G, 3)], length: KeyLength.eigth),
    //MARK: -15
    .init(notes: [.init(.A, 3), .init(.D, 3), .init(.F, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.A, 3), .init(.Csharp, 3), .init(.F, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.E, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 3), .init(.Csharp, 3), .init(.G, 3)], length: KeyLength.sixteenth),
    //MARK: -16
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.eigth),
    //MARK: -17
    .init(notes: [.init(.F, 2), .init(.Asharp, 3), .init(.D, 3)], length: KeyLength.fourth.extended),
    .init(notes: [.init(.D, 3), .init(.E, 3), .init(.Asharp, 4)], length: KeyLength.eigth),
    //MARK: -18
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.A, 3), .init(.D, 3), .init(.F, 3)], length: KeyLength.eigth),
    .init(notes: [.init(.E, 3)], length: KeyLength.eigth),
    //MARK: -19
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.A, 3), .init(.Csharp, 3), .init(.F, 3)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.E, 3)], length: KeyLength.sixteenth),
    //MARK: -20
    .init(notes: [.init(.F, 2), .init(.A, 3), .init(.D, 3), /*R:*/.init(.D, 2)], length: KeyLength.eigth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.sixteenth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.sixteenth),
    .init(notes: [.init(.D, 3), .init(.D, 4),/*R*/ .init(.D, 1)], length: KeyLength.eigth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.eigth),

    //MARK: -Line 4
    
    //MARK: -21
    .init(notes: [.init(.C, 3), .init(.E, 3), .init(.A, 4)], length: KeyLength.fourth.extended),
    .init(notes: [.init(.C, 3), .init(.E, 3)], length: KeyLength.eigth),
    //MARK: -22
    .init(notes: [.init(.Csharp, 3), .init(.E, 3), .init(.G, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.Csharp, 3), .init(.E, 3), .init(.G, 3)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.A, 4)], length: KeyLength.sixteenth),
    //MARK: -23
    .init(notes: [.init(.A, 3), .init(.D, 3), .init(.F, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.A, 3), .init(.C, 3), .init(.E, 3)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.B, 3), .init(.D, 3)], length: KeyLength.sixteenth),
    //MARK: -24
    .init(notes: [.init(.A, 3), .init(.C, 3), .init(.E, 3), /*R:*/.init(.D, 2)], length: KeyLength.eigth),
    .init(notes: [.init(.A, 3), .init(.A, 4), /*R:*/.init(.A, 1)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 3), .init(.A, 4)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 3), .init(.A, 4),/*R*/ .init(.C, 1)], length: KeyLength.eigth),
    .init(notes: [.init(.A, 3), .init(.A, 4),/*R*/ .init(.E, 1)], length: KeyLength.eigth),
    
    //MARK: -25
    .init(notes: [.init(.C, 3), .init(.E, 3), .init(.A, 4)], length: KeyLength.fourth.extended),
    .init(notes: [.init(.C, 3), .init(.E, 3)], length: KeyLength.eigth),
    //MARK: -26
    .init(notes: [.init(.Csharp, 3), .init(.E, 3), .init(.G, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.Csharp, 3), .init(.E, 3), .init(.G, 3)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.A, 4)], length: KeyLength.sixteenth),
    //MARK: -27
    .init(notes: [.init(.A, 3), .init(.D, 3), .init(.F, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.A, 3), .init(.C, 3), .init(.E, 3)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.B, 3), .init(.D, 3)], length: KeyLength.sixteenth),
    //MARK: -28
    .init(notes: [.init(.A, 3), .init(.C, 3), .init(.E, 3), /*R:*/.init(.A, 2)], length: KeyLength.eigth),
    .init(notes: [.init(.A, 3), .init(.A, 4), /*R:*/.init(.E, 1)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 3), .init(.A, 4)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 3), .init(.E, 3), .init(.A, 4),/*R*/ .init(.C, 1)], length: KeyLength.eigth),
    .init(notes: [.init(.E, 3), .init(.A, 4), .init(.C, 4),/*R*/ .init(.A, 1)], length: KeyLength.eigth),
    
    //MARK: -PAGE 2
    
    //MARK: -line 1
    //MARK: -1
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.Asharp, 4), .init(.D, 4)], length: KeyLength.half),
    //MARK: -2
    .init(notes: [.init(.E, 3), .init(.G, 3), .init(.C, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.E, 3), .init(.G, 3), .init(.Asharp, 4)], length: KeyLength.fourth),
    //MARK: -3
    .init(notes: [.init(.F, 3), .init(.A, 4), .init(.C, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.F, 3), .init(.A, 4), .init(.C, 4)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.D, 4)], length: .sixteenth),
    //MARK: -4
    .init(notes: [.init(.C, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.fourth.extended),
    .init(notes: [.init(.E, 3), .init(.G, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 4)], length: .sixteenth),
    //MARK: -5
    .init(notes: [.init(.F, 2), .init(.Asharp, 3), .init(.D, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.Asharp, 3), .init(.D, 3)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.F, 3)], length: KeyLength.sixteenth),
    
    //MARK: -line 2
    
    //MARK: -6
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.sixteenth),
    //MARK: -7
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.Asharp, 3), .init(.D, 3)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.F, 3)], length: KeyLength.sixteenth),
    //MARK: -8
    .init(notes: [.init(.D, 3), .init(.A, 4), .init(.C, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.D, 3), .init(.G, 3), .init(.Asharp, 4)], length: KeyLength.fourth),
    //MARK: -9
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.Asharp, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.Csharp, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.eigth),
    .init(notes: [.init(.E, 3), .init(.G, 3)], length: KeyLength.eigth),
    //MARK: -10
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.eigth),
    .init(notes: [.init(.E, 3), .init(.A, 4), .init(.C, 4)], length: KeyLength.eigth),
    
    //MARK: -line 3
    
    //MARK: -1
    //MARK: -1
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.Asharp, 4), .init(.D, 4)], length: KeyLength.half),
    //MARK: -2
    .init(notes: [.init(.E, 3), .init(.G, 3), .init(.C, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.E, 3), .init(.G, 3), .init(.Asharp, 4)], length: KeyLength.fourth),
    //MARK: -3
    .init(notes: [.init(.F, 3), .init(.A, 4), .init(.C, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.F, 3), .init(.A, 4), .init(.C, 4)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.D, 4)], length: .sixteenth),
    //MARK: -4
    .init(notes: [.init(.C, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.fourth.extended),
    .init(notes: [.init(.E, 3), .init(.G, 3)], length: KeyLength.sixteenth),
    .init(notes: [.init(.A, 4)], length: .sixteenth),
    //MARK: -5
    .init(notes: [.init(.F, 2), .init(.Asharp, 3), .init(.D, 3)], length: KeyLength.fourth),
    .init(notes: [.init(.Asharp, 3), .init(.D, 3)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.F, 3)], length: KeyLength.sixteenth),
    
    //MARK: -line 2
    
    //MARK: -6
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.sixteenth),
    //MARK: -7
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.Asharp, 3), .init(.D, 3)], length: KeyLength.eigth.extended),
    .init(notes: [.init(.F, 3)], length: KeyLength.sixteenth),
    //MARK: -8
    .init(notes: [.init(.D, 3), .init(.A, 4), .init(.C, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.D, 3), .init(.G, 3), .init(.Asharp, 4)], length: KeyLength.fourth),
    //MARK: -9
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.Asharp, 4)], length: KeyLength.fourth),
    .init(notes: [.init(.Csharp, 3), .init(.F, 3), .init(.A, 4)], length: KeyLength.eigth),
    .init(notes: [.init(.E, 3), .init(.G, 3)], length: KeyLength.eigth),
    //MARK: -10
    .init(notes: [.init(.D, 3), .init(.F, 3), .init(.A, 4), .init(.D, 4)], length: KeyLength.eigth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.sixteenth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.sixteenth),
    .init(notes: [.init(.D, 3), .init(.D, 4),/*R*/ .init(.D, 1)], length: KeyLength.eigth),
    .init(notes: [.init(.D, 3), .init(.D, 4)], length: KeyLength.eigth),
    
]


