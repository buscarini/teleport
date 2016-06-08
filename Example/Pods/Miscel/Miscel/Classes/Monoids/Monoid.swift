//
//  Monoid.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 3/6/16.
//
//

import Foundation

public protocol Monoid {
	static var unit: Self { get }
	
	static func combine(left: Self, _ right: Self) -> Self
}
