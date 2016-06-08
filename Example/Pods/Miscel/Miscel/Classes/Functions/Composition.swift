//
//  Composition.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 1/6/16.
//
//

import Foundation

// MARK: Functions
public func compose<a,b,c>(f: (b) -> (c), _ g: (a) -> (b) ) -> (a) -> (c) {
	return { f(g($0)) }
}

public func compose<a,b,c,d,e,f>(f: (c, d) -> (e, f), _ g: (a, b) -> (c, d) ) -> (a, b) -> (e, f) {
	return { f(g($0, $1)) }
}

public func compose<a,b,c,d,e,f,g,h,i>(f: (d, e, f) -> (g, h, i), _ g: (a, b, c) -> (d, e, f) ) -> (a, b, c) -> (g, h, i) {
	return { f(g($0, $1, $2)) }
}

public func compose<a,b,c,d,e,f,g,h,i,j,k,l>(f: (e, f, g, h) -> (i, j, k, l), _ g: (a, b, c, d) -> (e, f, g, h) ) -> (a, b, c, d) -> (i, j, k, l) {
	return { f(g($0, $1, $2, $3)) }
}

// MARK: Operator
infix operator ∘ { associativity left precedence 160 }

public func ∘<a,b,c>(f: (b) -> (c), _ g: (a) -> (b) ) -> (a) -> (c) {
    return compose(f, g)
}

public func ∘<a,b,c,d,e,f>(f: (c, d) -> (e, f), _ g: (a, b) -> (c, d) ) -> (a, b) -> (e, f) {
	return { f(g($0, $1)) }
}

public func ∘<a,b,c,d,e,f,g,h,i>(f: (d, e, f) -> (g, h, i), _ g: (a, b, c) -> (d, e, f) ) -> (a, b, c) -> (g, h, i) {
	return { f(g($0, $1, $2)) }
}

public func ∘<a,b,c,d,e,f,g,h,i,j,k,l>(f: (e, f, g, h) -> (i, j, k, l), _ g: (a, b, c, d) -> (e, f, g, h) ) -> (a, b, c, d) -> (i, j, k, l) {
	return { f(g($0, $1, $2, $3)) }
}

