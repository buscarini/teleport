//
//  Sequence+Equatable.swift
//  Miscel
//
//  Created by José Manuel Sánchez Peñarroja on 27/4/16.
//
//

import Foundation

public func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case (.Some(let lhs), .Some(let rhs)):
        return lhs == rhs
    case (.None, .None):
        return true
    default:
        return false
    }
}

