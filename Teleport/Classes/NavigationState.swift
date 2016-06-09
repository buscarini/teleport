//
//  NavigationState.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import Foundation

import Miscel

public indirect enum NavigationState {
	case Empty
	case ViewController(AnyClass, child: NavigationState?)
	case NavigationController([NavigationState])
	
	var description: String {
		switch self {
			case .Empty:
				return "Empty"
			case .ViewController(let c, let child):
				return "VC\n\t(\(TypeUtils.name(c)), child: \(child))"
			case .NavigationController(let states):
				return "NAVC\n\t(states: \(states))"
		}
	}
}

extension NavigationState: Hashable {
    public var hashValue: Int {
		switch self {
			case .Empty:
				return "Empty".hashValue
			case .ViewController(let viewClass, let child):
				return "ViewController(\(TypeUtils.name(viewClass).hashValue),\(child?.hashValue))".hashValue
			case NavigationController(let states):
				return "NavigationController(\(states.hashValue))".hashValue
		}
    }
}

extension NavigationState: Equatable { }
public func == (lhs: NavigationState, rhs: NavigationState) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


