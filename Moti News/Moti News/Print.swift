//
//  Print.swift
//  Moti News
//
//  Created by Modestas Valauskas on 10.07.16.
//  Copyright © 2016 Modestas Valauskas. All rights reserved.
//

import Foundation


class Print {
    static func p(b: Bool, t: Any...) {
        if(b) { print(t) }
    }
}