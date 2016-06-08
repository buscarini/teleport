//
//  UIView.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

import Layitout

public extension UIView {
	public static func removeAllSubviews(view:UIView) {
		for subview in view.subviews {
			subview.removeFromSuperview()
		}
	}
	
	public static func addSubviews(view: UIView, subviews: [UIView]) {
		for subview in subviews {
			view.addSubview(subview)
		}
	}
}
