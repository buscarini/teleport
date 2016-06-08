//
//  Writer.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 3/6/16.
//
//

import Foundation

public struct Writer<T, L: Monoid> {
	let value: T
	let log: L

	public var run: (T, L) {
		return (value, log)
	}
	
	public init(_ value: T, _ log: L) {
		self.value = value
		self.log = log
	}
	
	public static func of(value: T) -> Writer {
		return Writer(value, L.unit)
	}
	
	public func map<U>(f: (T) -> (U)) -> Writer<U,L> {
		return Writer<U, L>(f(value), log)
	}

	public func flatMap<U>(f: (T) -> Writer<U, L>) -> Writer<U, L> {
		let writer = f(value)
		return Writer<U, L>(writer.value, L.combine(log, writer.log))
	}
}

