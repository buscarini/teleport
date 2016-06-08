//
//  UIView+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 18/5/16.
//
//

import UIKit

public extension UIView {
	public static func fill(container: UIView, subview: UIView) {
		container.addSubview(subview)
		subview.translatesAutoresizingMaskIntoConstraints = false
		Layout.fill(container, view: subview, priority: UILayoutPriorityRequired)
	}
}
