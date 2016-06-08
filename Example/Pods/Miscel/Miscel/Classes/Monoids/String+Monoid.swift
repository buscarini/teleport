//
//  String.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 3/6/16.
//
//

import Foundation

extension String: Monoid {
	public static var unit: String {
		return ""
	}
	
	public static func combine(left: String, _ right: String) -> String {
		return left + right
	}
}
