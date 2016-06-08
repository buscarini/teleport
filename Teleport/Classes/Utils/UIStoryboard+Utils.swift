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
	public static func loadView(c: AnyClass) -> AnyClass? {
		guard let view = UIStoryboard(name: TypeUtils.name(c), bundle: nil).instantiateInitialViewController() as? AnyClass else {
			return nil
		}
		
		return view
	}
}
