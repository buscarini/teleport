//
//  Folds.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 5/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

public extension CollectionType {
	
//	func reduce1(f:(Self.Generator.Element,Self.Generator.Element) -> Self.Generator.Element)(_ xs:[Self.Generator.Element]) -> Self.Generator.Element? {
//		return self.first.map { x in
//			self.tail().reduce(x, f)
//		}
//	}
	
	public func head() -> Self.Generator.Element? {
		return self.first
	}
	
	public func tail() -> Self.SubSequence {
		let secondIndex = self.startIndex.advancedBy(1)

		return self.suffixFrom(secondIndex)
	}
	
	public func foldr<B>(accm:B, f: (Self.Generator.Element, B) -> B) -> B {
		var g = self.generate()
		func next() -> B {
			return g.next().flatMap {x in f(x, next())} ?? accm
		}
		return next()
	}
	
	public func foldl<B>(accm:B, f: (Self.Generator.Element, B) -> B) -> B {
		var result = accm
		for temp in self {
			result = f(temp, result)
		}
		return result
	}	
}

