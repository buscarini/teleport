//
//  NavigationComponent.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//
//

import UIKit

import RxSwift
import Miscel

enum NavigationError: ErrorType {
	case StoryboardNotFound
	case EmptyViewController
	case Unknown
}

public class Teleport: NSObject {
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
		
		self.updateActions(window, oldState: oldState, state: state).subscribeNext {
			_ in
			
		}
	}
	
	func updateActions(window: UIWindow, oldState: NavigationState, state: NavigationState) -> Observable<UIViewController> {
		let root = window.rootViewController
		switch (oldState, state) {
			case (_ , .Empty):
				guard let root = root else {
					return Observable.error(NavigationError.EmptyViewController)
				}
				
				return Observable.just(root)
		
			case (.Empty, _):
				let (result, setupChild) = self.loadView(state)
				
				return result
					.flatMap { Teleport.install(window, vc: $0) }
					.flatMap(setupChild)
			
			case (.ViewController(let c1, let child1), .ViewController(let c2, let child2)) where c1 != c2:
				let (result, setupChild) = self.loadView(state)
				
				return self.installVC(result, setupChildren: setupChild) {
					Teleport.install(window, vc: $0)
				}
				
//				result
//				.flatMap { NavigationComponent.install(window, vc: $0) }
//				.flatMap(setupChild)
			
			case (.ViewController(let c1, let child1), .ViewController(let c2, let child2)) where child1 != child2:
				// TODO: Implement this
				var result = Observable.just(root!)
				
				if let child1 = child1 {
					result = result.flatMap {
						return Teleport.dismiss($0, vc: $0)
					}
				}
				
				if let child2 = child2 {
				
					result = result.flatMap { mainVC -> Observable<UIViewController> in
						let (result, setupChild) = self.loadView(child2)
						
						return self.installVC(result, setupChildren: setupChild) {
							Teleport.present(mainVC, vc: $0)
						}
					}
				}
				
				return result
			
			case (.NavigationController(let states1), .NavigationController(let states2)):
				// TODO: Implement this
				guard let navC = root as? UINavigationController else {
					let (result, setupChild) = self.loadView(state)
					
					return self.installVC(result, setupChildren: setupChild) {
						Teleport.install(window, vc: $0)
					}
				}
				
				let (common, new) = Teleport.commonSubsequence(states1, states: states2)
				
				let tuples = new.map(self.loadView)
					
				let results = tuples.map { (result, _) in return result }
				let setupChildren = tuples.map { (_, setupChild) in return setupChild }
				
				return results // [Observable<UIViewController>]
						.toObservable() // Observable<[Observable<UIViewController>]>
						.merge() // Observable<UIViewController>
						.toArray() // Observable<[UIViewController]>
						.flatMap { vcs -> Observable<UIViewController> in
							let commonViews = Array(navC.viewControllers.prefix(common.count))
							return Teleport.replace(navC as! UINavigationController, with: commonViews + vcs, animated: true)
						}  // Observable<UIViewController>
						.flatMap { navC in
							return setupChildren.flatMap { $0(navC) }
								.toObservable()
								.merge()
								.toArray()
								.map { vcs in
									return navC
								}
						}
			
			case (.ViewController, .NavigationController), (.NavigationController, .ViewController):
				let (result, setupChild) = self.loadView(state)
				
				return self.installVC(result, setupChildren: setupChild) {
					Teleport.install(window, vc: $0)
				}
			
			default:
				return Observable.just(root!)
		}
	}
	
	func installVC(create: Observable<UIViewController>, setupChildren: (UIViewController) -> Observable<UIViewController>, install: (UIViewController) -> Observable<UIViewController>) -> Observable<UIViewController> {
	
		return create.flatMap(install).flatMap(setupChildren)
	}
	
	func loadView(state: NavigationState) -> (create: Observable<UIViewController>, setupChildren: (UIViewController) -> Observable<UIViewController>)  {
	
		switch state {
			case .Empty:
				return (Observable.error(NavigationError.EmptyViewController), { Observable.just($0) })
			
			case .ViewController(let c, let child):
				let vc = self.loadViewController(c)
				let result = Observable.just(vc)
			
				let setupChild: (UIViewController) -> Observable<UIViewController>
			
				if let child = child {
					setupChild = { vc in
						let (childResult, setupDesc) = self.loadView(child)
						return childResult
						.flatMap {
							Teleport.present(vc, vc: $0, animated: true)
						}
						.flatMap(setupDesc)
					}
				}
				else {
					setupChild = { Observable.just($0) }
				}
			
				return (result, setupChild)
			
			case .NavigationController(let states):
			
				let navC = UINavigationController()
				navC.delegate = self


				let tuples = states.map(self.loadView)
				let results = tuples.map { (result, _) in return result }
				let setupChildren = tuples.map { (_, setupChild) in return setupChild }
				
				let result: Observable<UIViewController> = Observable.just(navC).flatMap {
					vc in
					
					return results
						.toObservable()
						.merge()
						.toArray()
						.flatMap { vcs in
							Teleport.replace(navC as! UINavigationController, with: vcs, animated: false)
						}
				}
				
				let setupChild: (UIViewController) -> Observable<UIViewController> = {
					vc in
					
					setupChildren.map { $0(navC) }.toObservable()
						.merge()
						.toArray()
						.map { _ in
							navC
						}
				}
			
				return (result, setupChild)
		}
	}
	
	func loadViewController(aClass: AnyClass) -> UIViewController {
		return UIStoryboard.loadView(aClass)!
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


extension Teleport: UINavigationControllerDelegate {
	public func navigationController(_ navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated animated: Bool) {
	
		// TODO: Implement this
		guard let rootVC = window.rootViewController else {
			return
		}
		
		// TODO: Update state without side effects
		self.currentState = Teleport.changeSubState(forViewController: navigationController, rootVC: rootVC, rootState: self.state) {
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


