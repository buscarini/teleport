//
//  UIBarButtonItem.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 8/1/16.
//  Copyright © 2016 vitaminew. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
	public static func flexibleSpaceItem() -> UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
	}
	
	public static func fixedSpaceItem() -> UIBarButtonItem {
		let button = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
		button.width = 10
		return button
	}
}
