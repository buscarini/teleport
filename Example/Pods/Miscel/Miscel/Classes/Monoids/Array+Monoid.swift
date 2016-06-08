//
//  SequenceType+Monoid.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 6/6/16.
//
//

import Foundation

extension Array: Monoid {
	public static var unit: Array {
		return Array()
	}
	
	public static func combine(left: Array, _ right: Array) -> Array {
		return left + right
	}
}

