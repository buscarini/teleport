//
//  NavigationComponent+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import UIKit

import RxSwift
import Miscel

extension Teleport {
	
	static func commonSubsequence(oldStates: [NavigationState], states: [NavigationState]) -> (common: [NavigationState], new: [NavigationState]) {
	
		switch (oldStates.count, states.count) {
			case (0, _):
				return ([], states)
			case (_, 0):
				return ([], [])
			
			default:
				guard let state1 = oldStates.first, let state2 = states.first else {
					fatalError("This should never happen")
				}
			
				guard state1 == state2 else {
					return ([], states)
				}
				
				let subResult = commonSubsequence(Array(oldStates.dropFirst(1)), states: Array(states.dropFirst(1)))
				return ([state2] + subResult.common, subResult.new)
		}
	
	}
	
	static func changeSubState(forViewController vc: UIViewController, rootVC: UIViewController, rootState: NavigationState, change: (NavigationState) -> (NavigationState)) -> NavigationState {
		// TODO: Implement this
		guard vc != rootVC else {
			return change(rootState)
		}
		
		switch rootState {
			case .ViewController(let vcClass, let child):
				guard let child = child, let childVC = rootVC.presentedViewController else {
					// vc is not in the hierarchy
					return rootState
				}
			
				return .ViewController(vcClass, child: changeSubState(forViewController: vc, rootVC: childVC, rootState: child, change: change))
			
			case .NavigationController(let states):
				guard let navC = rootVC as? UINavigationController else {
					fatalError("ERROR: this shouldn't happen. VCs and state out of sync")
				}
			
				return .NavigationController(zip(navC.viewControllers, states).flatMap {
					childVC, state in
					return changeSubState(forViewController: vc, rootVC: childVC, rootState: state, change: change)
				})
			
			default:
				// vc is not in the hierarchy
				return rootState
		}
		
	}
}
