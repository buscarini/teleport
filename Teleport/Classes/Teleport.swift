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

typealias ViewControllerAction = Observable<UIViewController>
typealias SetupChildrenAction = (UIViewController) -> Observable<UIViewController>

struct ViewControllerInstall {
	var create: ViewControllerAction
	var setupChild: SetupChildrenAction
	
	init(create: ViewControllerAction, setupChild: SetupChildrenAction? = nil) {
		self.create = create
		let emptyAction: SetupChildrenAction = { Observable.just($0) }
		self.setupChild = setupChild != nil ? setupChild! : emptyAction
	}
	
	
	// MARK: Utils
	func createAction(install: SetupChildrenAction) -> ViewControllerAction {
		return self.create
					.flatMap(install)
					.flatMap(self.setupChild)
	}
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
		
		self.updateActions(Teleport.root(window), oldState: oldState, state: state).createAction {
			Teleport.install(self.window, vc: $0)
		}.subscribe(onNext: {
				_ in
			
			}, onError: {
				_ in
				
			},
			onCompleted: nil,
			onDisposed: nil)
		
		
//		.subscribeNext {
//			_ in
//			print("finished")
//		}
	}
	
	func updateActions(root: UIViewController?, oldState: NavigationState, state: NavigationState) -> ViewControllerInstall {
		
		switch (oldState, state) {
			case (_ , .Empty):
				guard let root = root else {
					return ViewControllerInstall(create: Observable.error(NavigationError.EmptyViewController))
				}
				
				return ViewControllerInstall(create: Observable.just(root))
		
			case (.Empty, _):
				return self.loadView(state)
			
			case (.ViewController(let c1, let child1), .ViewController(let c2, let child2)) where c1 != c2:
				return self.loadView(state)
		
			case (.ViewController(let c1, let child1), .ViewController(let c2, let child2)) where child1 != child2:
				// TODO: Implement this
				var result = Observable.just(root!)
				
				guard let oldChild = child1, newChild = child2 where NavigationState.sameRootView(child1, state2: child2) else {
					if let child1 = child1 {
						result = result.flatMap {
							return Teleport.dismiss($0, vc: $0)
						}
					}
					
					if let child2 = child2 {
						result = result.flatMap { mainVC -> Observable<UIViewController> in
							return self.loadView(child2).createAction() {
								Teleport.present(mainVC, vc: $0)
							}
						}
					}
					
					return ViewControllerInstall(create: result)
				}
		
		
				return self.updateActions(root?.presentedViewController, oldState: oldChild, state: newChild)
				// TODO: Implement this
//				self.updateActions(<#T##window: UIWindow##UIWindow#>, oldState: oldChild, state: newChild)
//				return ViewControllerInstall(create: result)
			
			case (.NavigationController(let states1), .NavigationController(let states2)):
				// TODO: Implement this
				guard let navC = root as? UINavigationController else {
					return self.loadView(state)
				}
				
				let (common, new) = Teleport.commonSubsequence(states1, states: states2)
				
				let installs = new.map(self.loadView)
					
				let results = installs.map { $0.create }
				let setupChildren = installs.map { $0.setupChild }
				
				return ViewControllerInstall(create: results // [Observable<UIViewController>]
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
						})
			
			case (.TabBar(let states1, let selected1), .TabBar(let states2, let selected2)):
				// TODO: Implement this
				guard let tabBarC = root as? UITabBarController else {
					return self.loadView(state)
				}
				
				let (common, new) = Teleport.commonSubsequence(states1, states: states2)
				
				let installs = new.map(self.loadView)
					
				let results = installs.map { $0.create }
				let setupChildren = installs.map { $0.setupChild }
				
				return ViewControllerInstall(create: results // [Observable<UIViewController>]
						.toObservable() // Observable<[Observable<UIViewController>]>
						.merge() // Observable<UIViewController>
						.toArray() // Observable<[UIViewController]>
						.flatMap { vcs -> Observable<UIViewController> in
							let controllers = tabBarC.viewControllers ?? []
							let commonViews = Array(controllers.prefix(common.count))
							return Teleport.replace(tabBarC as! UITabBarController, with: commonViews + vcs, animated: true)
						}  // Observable<UIViewController>
						.flatMap { _ in
							return Teleport.select(tabBarC as! UITabBarController, index: selected2)
						}
						.flatMap { navC in
							return setupChildren.flatMap { $0(tabBarC) }
								.toObservable()
								.merge()
								.toArray()
								.map { vcs in
									return tabBarC
								}
						})
			
			case (.ViewController, .NavigationController), (.NavigationController, .ViewController), (.ViewController, .TabBar), (.TabBar, .ViewController), (.TabBar, .NavigationController), (.NavigationController, .TabBar):
				return self.loadView(state)
			
			default:
				return ViewControllerInstall(create: Observable.just(root!))
		}
	}

//	func installVC(create: Observable<UIViewController>, setupChildren: (UIViewController) -> Observable<UIViewController>, install: (UIViewController) -> Observable<UIViewController>) -> Observable<UIViewController> {
//	
//		return create.flatMap(install).flatMap(setupChildren)
//	}
	
	func loadView(state: NavigationState) -> ViewControllerInstall {
		switch state {
			case .Empty:
				return ViewControllerInstall(create: Observable.error(NavigationError.EmptyViewController), setupChild: { Observable.just($0) } )
			
			case .ViewController(let c, let child):
			
				print("create vc")
				let vc = self.loadViewController(c)
				let result = Observable.just(vc).doOnCompleted({ print("finished vc creation") })
			
				let setupChild: (UIViewController) -> Observable<UIViewController>
			
				if let child = child {
					setupChild = { vc in
						let install = self.loadView(child)
						let (childResult, setupDesc) = (install.create, install.setupChild)
						return childResult
						.flatMap {
							Teleport.present(vc, vc: $0, animated: true)
						}
						.flatMap(setupDesc)
						.doOnCompleted({ print("finished vc child setup") })
					}
				}
				else {
					setupChild = { Observable.just($0) }
				}
			
				return ViewControllerInstall(create: result, setupChild: setupChild )

			case .NavigationController(let states):
			
				print("create nav c")
				let navC = UINavigationController()
				navC.delegate = self

				let tuples = states.map(self.loadView)
				let results = tuples.map { $0.create }
				let setupChildren = tuples.map { $0.setupChild }
				
				let result: Observable<UIViewController> = Observable.just(navC)
					.flatMap {
						vc in
						
						return results
							.toObservable()
							.merge()
							.toArray()
							.flatMap { vcs in
								Teleport.replace(navC, with: vcs, animated: false)
							}
					}
				
				let setupChild: (UIViewController) -> ViewControllerAction = {
					vc in
					
					setupChildren.map { $0(navC) }.toObservable()
						.merge()
						.toArray()
						.map { _ in
							navC
						}
				}
			
				return ViewControllerInstall(create: result, setupChild: setupChild)
			
			case .TabBar(let states, let selected):
			
				print("create tab bar")
				let tabBarC = UITabBarController()
				tabBarC.delegate = self

				let tuples = states.map(self.loadView)
				let results = tuples.map { $0.create }
				let setupChildren = tuples.map { $0.setupChild }
				
				let result: Observable<UIViewController> = Observable.just(tabBarC).flatMap {
					vc in
					
					return results
						.toObservable()
						.merge()
						.toArray()
						.flatMap { vcs in
							Teleport.replace(tabBarC, with: vcs, animated: true)
						}
						.flatMap { vcs in
							Teleport.select(tabBarC, index: selected)
						}
				}
				
				let setupChild: (UIViewController) -> ViewControllerAction = {
					vc in
					
					setupChildren.map { $0(tabBarC) }.toObservable()
						.merge()
						.toArray()
						.map { _ in
							tabBarC
						}
				}
			
				return ViewControllerInstall(create: result, setupChild: setupChild)
		}
	}
	
	func loadViewController(aClass: AnyClass) -> UIViewController {
		return UIStoryboard.loadView(aClass)!
	}
	
}


extension Teleport: UINavigationControllerDelegate {
	public func navigationController(_ navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated animated: Bool) {
	
		// TODO: Implement this
		guard let rootVC = Teleport.root(window) else {
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

extension Teleport: UITabBarControllerDelegate {
	// TODO: Detect when the selected tab changes
}


