//
//  NavigationComponent.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import UIKit

import Miscel

public class NavigationComponent {
	let window: UIWindow
	
	public var state: NavigationState {
		didSet {
			update(oldValue, state: state)
		}
	}

	public init(window: UIWindow, initialState: NavigationState) {
		self.window = window
		self.state = initialState
	}


	func update(oldState: NavigationState, state: NavigationState) {
		guard oldState != state else { return }
		
		window.rootViewController = self.viewControllerForUpdate(window.rootViewController, oldState: oldState, state: state)
	}
	
	func viewControllerForUpdate(current: UIViewController?, oldState: NavigationState, state: NavigationState) -> UIViewController? {
		switch (oldState, state) {
			case (_ , .Empty):
				return nil
		
			case (.Empty, _):
				return self.loadView(state)
		
			case (.ViewController(let c1, let child1), .ViewController(let c2, let child2)) where c1 != c2:
				return self.loadView(state)
			
			case (.ViewController(let c1, let child1), .ViewController(let c2, let child2)) where child1 != child2:
				// TODO: Implement this
				return current
			
			case (.NavigationController(let state1), .NavigationController(let state2)):
			// TODO: Implement this
				return current
			
			case (.ViewController, .NavigationController), (.NavigationController, .ViewController):
				return loadView(state)
			
			default:
				return current
		}
	}
	
	func loadView(state: NavigationState) -> UIViewController? {
		switch state {
			case .Empty:
				return nil
			
			case .ViewController(let c, let child):
				return self.loadViewController(c)
			
			case .NavigationController(let states):
				let navC = UINavigationController()
				navC.viewControllers = states.flatMap(self.loadView)
				return navC
		}
	}
	
	func loadViewController(aClass: AnyClass) -> UIViewController {
		return UIStoryboard.loadView(aClass)!
	}
}

