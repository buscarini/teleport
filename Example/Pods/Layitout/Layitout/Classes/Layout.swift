//
//  LayoutUtils.swift
//  cibo
//
//  Created by Jose Manuel Sánchez Peñarroja on 15/10/15.
//  Copyright © 2015 treenovum. All rights reserved.
//

import UIKit

public struct Layout {
	public static func fill(container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriorityRequired) {
		Layout.fillH(container, view: view, priority: priority)
		Layout.fillV(container, view: view, priority: priority)
	}
	
	public static func fillV(container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriorityRequired) {
		let constraints : [NSLayoutConstraint]
		
		if #available(iOS 9.0, *) {
			constraints = [
				container.topAnchor.constraintEqualToAnchor(view.topAnchor),
				container.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
			]
		} else {
			constraints = [
				NSLayoutConstraint(item: container, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: container, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
			]
		}
		
		for constraint in constraints {
			constraint.priority = priority
		}
		
		container.addConstraints(constraints)
	}

	public static func fillH(container: UIView, view : UIView, priority: UILayoutPriority = UILayoutPriorityRequired) {
		let constraints : [NSLayoutConstraint]
		
		if #available(iOS 9.0, *) {
			constraints = [
				container.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
				container.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
			]
		} else {
			constraints = [
				NSLayoutConstraint(item: container, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0),
				NSLayoutConstraint(item: container, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0),
			]
		}
		
		for constraint in constraints {
			constraint.priority = priority
		}
		
		container.addConstraints(constraints)

	}
		
	public static func equal(view1: UIView,view2 : UIView, attribute: NSLayoutAttribute, multiplier : CGFloat = 1, constant : CGFloat = 0, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: view1, attribute: attribute, relatedBy: .Equal, toItem: view2, attribute: attribute, multiplier: multiplier, constant: constant)
		constraint.priority = priority
		return constraint
	}

	public static func equal(view : UIView, attribute: NSLayoutAttribute, constant : CGFloat, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: constant)
		constraint.priority = priority
		return constraint
	}
}
