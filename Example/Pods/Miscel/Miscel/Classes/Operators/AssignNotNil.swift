//
//  AssignNotNil.swift
//  Unsorted
//
//  Created by José Manuel Sánchez Peñarroja on 12/5/16.
//  Copyright © 2016 vitaminew. All rights reserved.
//

import Foundation

infix operator ?= {
    associativity right
    precedence 90
    assignment
}

public func ?= <T>(inout lhs: T, rhs: T?) {
    lhs = rhs ?? lhs
}

