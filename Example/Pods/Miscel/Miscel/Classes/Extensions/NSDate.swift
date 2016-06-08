//
//  NSDate.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/3/16.
//  Copyright © 2016 vitaminew. All rights reserved.
//

import Foundation

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }

