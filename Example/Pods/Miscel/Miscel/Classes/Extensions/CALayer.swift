//
//  CALayer.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 17/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

public class NullAction: CAAction {
	@objc public func runActionForKey(event: String, object anObject: AnyObject, arguments dict: [NSObject : AnyObject]?) {
		// Do nothing.
	}
}

public extension CALayer {
	public static func disableAnimations(layer: CALayer) {
		layer.actions = [
			"frame" : NullAction(),
			"bounds" : NullAction(),
			"position" : NullAction(),
			"backgroundColor" : NullAction(),
			"opacity" : NullAction()
		]
	}
	
	public static func performWithoutAnimation(block: ()->()) {
		CATransaction.begin()
		CATransaction.disableActions()
		block()
		CATransaction.commit()
	}
}
