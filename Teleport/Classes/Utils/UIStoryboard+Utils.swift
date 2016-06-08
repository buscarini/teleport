//
//  UIStoryboard+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import UIKit

import Miscel

extension UIStoryboard {
	public static func loadView(c: AnyClass) -> UIViewController? {
		guard let view = UIStoryboard(name: TypeUtils.name(c), bundle: nil).instantiateInitialViewController() else {
			return nil
		}
		
		return view
	}
}
