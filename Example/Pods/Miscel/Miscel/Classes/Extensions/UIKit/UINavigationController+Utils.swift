//
//  UINavigationController+Utils.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 10/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

extension UINavigationController {
	public func pushViewController(viewController: UIViewController, animated: Bool, completion: () -> ()) {
		CATransaction.begin()
		CATransaction.setCompletionBlock(completion)
		pushViewController(viewController, animated: animated)
		CATransaction.commit()
	}

	public func popViewController(animated: Bool, completion: () -> ()) {
		CATransaction.begin()
		CATransaction.setCompletionBlock(completion)
		popViewControllerAnimated(true)
		CATransaction.commit()
	}
}
