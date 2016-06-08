//
//  NavigationComponent.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import UIKit

import Miscel

public class NavigationComponent: NSObject {
	let window: UIWindow
	
	private var currentState: NavigationState
	
	public var state: NavigationState {
		get {
			return currentState
		}
		set(value) {
			update(currentState, state: value)
			currentState = value
		}
	}

	public init(window: UIWindow, initialState: NavigationState) {
		self.window = window
		self.currentState = initialState
	}


	func update(oldState: NavigationState, state: NavigationState) {
		guard oldState != state else { return }
		
		window.rootViewController = self.viewControllerForUpdate(window.rootViewController, oldState: oldState, state: state)
	}
	
	func viewControllerForUpdate(root: UIViewController?, oldState: NavigationState, state: NavigationState) -> UIViewController? {
		switch (oldState, state) {
			case (_ , .Empty):
				return nil
		
			case (.Empty, _):
				return self.loadView(state)
		
			case (.ViewController(let c1, let child1), .ViewController(let c2, let child2)) where c1 != c2:
				return self.loadView(state)
			
			case (.ViewController(let c1, let child1), .ViewController(let c2, let child2)) where child1 != child2:
				// TODO: Implement this
				if let child1 = child1 {
					root?.dismissViewControllerAnimated(false, completion: { 
						
					})
				}
				
				if let child2 = child2, let childVC = self.loadView(child2) {
					root?.presentViewController(childVC, animated: true, completion: nil)
				}
				
				return root
			
			case (.NavigationController(let states1), .NavigationController(let states2)):
				// TODO: Implement this
				guard let navC = root as? UINavigationController else {
					return root
				}
				
				let (common, new) = NavigationComponent.commonSubsequence(states1, states: states2)
				let newViews = new.flatMap(self.loadView)
				
				if common.count == navC.viewControllers.count {
					// Only push
					navC.pushViewControllers(newViews, animated: true)
				}
				else {
					let commonViews = Array(navC.viewControllers.prefix(common.count))
				
					navC.setViewControllers(commonViews + newViews, animated: true)
				}
			
				return root
			
			case (.ViewController, .NavigationController), (.NavigationController, .ViewController):
				return loadView(state)
			
			default:
				return root
		}
	}
	
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
	
	func loadView(state: NavigationState) -> UIViewController? {
		switch state {
			case .Empty:
				return nil
			
			case .ViewController(let c, let child):
				let vc = self.loadViewController(c)
			
				if let child = child, let childVC = self.loadView(child) {
					vc.presentViewController(childVC, animated: false, completion: nil)
				}
			
				return vc
			
			case .NavigationController(let states):
				let navC = UINavigationController()
				navC.delegate = self
				navC.viewControllers = states.flatMap(self.loadView)
				return navC
		}
	}
	
	func loadViewController(aClass: AnyClass) -> UIViewController {
		return UIStoryboard.loadView(aClass)!
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


extension NavigationComponent: UINavigationControllerDelegate {
	public func navigationController(_ navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated animated: Bool) {
	
		// TODO: Implement this
		guard let rootVC = window.rootViewController else {
			return
		}
		
		// TODO: Update state without side effects
		self.currentState = NavigationComponent.changeSubState(forViewController: navigationController, rootVC: rootVC, rootState: self.state) {
			substate in
			
			switch substate {
				case .NavigationController(let states) where states.count != navigationController.viewControllers.count:
					// TODO: Change substate
					return .NavigationController(Array(states.prefix(navigationController.viewControllers.count)))
				
				default:
					return substate
			}
		}
		
	}
}


