//
//  Base.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 1/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

public func with<T>(constant: T, @noescape update: (inout T) throws ->() ) rethrows -> T {
	var variable = constant
	try update(&variable)
	return variable
}

public func delay(time: NSTimeInterval, closure: () -> ()) {
	let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
	dispatch_after(delayTime, dispatch_get_main_queue(), closure)
}
