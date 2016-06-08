//
//  TypeUtils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 7/6/16.
//
//

import Foundation

public struct TypeUtils {
	public static func name(thing: Any) -> String {
		return String(thing.self)
	}
}

