//
//  Sum.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 3/6/16.
//
//

import Foundation

public struct Sum: Monoid {
	public var value: Int
	
	public init(_ value: Int) {
		self.value = value
	}

	public static var unit: Sum {
		return Sum(0)
	}
	
	public static func combine(left: Sum, _ right: Sum) -> Sum {
		return Sum(left.value + right.value)
	}
}
