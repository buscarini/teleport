//
//  Array.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

public func removingDuplicates<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
	var buffer = [T]()
	var added = Set<T>()
	for elem in source {
		if !added.contains(elem) {
			buffer.append(elem)
			added.insert(elem)
		}
	}
	return buffer
}

// http://stackoverflow.com/a/31444592
extension Array where Element: Hashable {
	public var hashValue: Int {
		let result = self.reduce(5381) {
			($0 << 5) &+ $0 &+ $1.hashValue
		}
		return result
	}
}
