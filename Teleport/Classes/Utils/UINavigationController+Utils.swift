//
//  UINavigationController+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import UIKit

extension UINavigationController {
	public func pushViewControllers(viewControllers: [UIViewController], animated: Bool) {
		guard viewControllers.count > 0 else { return }
		
		if let vc = viewControllers.first where viewControllers.count == 1 {
			self.pushViewController(vc, animated: animated)
		}
		else {
			self.setViewControllers(self.viewControllers + viewControllers, animated: animated)
		}
	}
}

