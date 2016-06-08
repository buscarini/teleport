//
//  Boolean.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 1/6/16.
//
//

import Foundation

public func not<a>(f: (a)->(Bool)) -> (a) -> Bool {
	return { !f($0) }
}

public func and<a>(f: (a) -> (Bool), _ g: (a) -> (Bool)) -> (a) -> Bool {
	return { f($0) && g($0) }
}

public func and<a>(fs: [(a) -> (Bool)] ) -> (a) -> Bool {
	return { (input: a) -> Bool in
		fs.reduce(true, combine: { (result, f: (a) -> Bool) -> Bool in
			return result && f(input)
		})
	}
}

public func or<a>(fs: [(a) -> (Bool)] ) -> (a) -> Bool {
	return { (input: a) -> Bool in
		fs.reduce(false, combine: { (result, f: (a) -> Bool) -> Bool in
			return result || f(input)
		})
	}
}


