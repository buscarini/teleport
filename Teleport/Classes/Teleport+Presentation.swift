//
//  Teleport+Presentation.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 9/6/16.
//
//

import UIKit

import RxSwift
import Miscel

extension Teleport {
// MARK: Window Root
	static func install(window: UIWindow, vc: UIViewController, animated: Bool = true) -> ViewControllerAction {
		return Observable.create { observer in
		
			print("install")
			window.rootViewController = vc

			// Required to avoid unbalanced transition calls
			delay(0.01) {
				observer.onNext(vc)
			}

			return AnonymousDisposable {}
		}
	}
	
	// MARK: Modal
	static func present(from: UIViewController, vc: UIViewController, animated: Bool = true) -> ViewControllerAction {
		return Observable.create { observer in
			print("present")
			from.presentViewController(vc, animated: animated) {
				observer.onNext(from)
			}
		
			return AnonymousDisposable {}
		}
	}
	
	static func dismiss(from: UIViewController, vc: UIViewController, animated: Bool = true) -> ViewControllerAction {
		return Observable.create { observer in
		
			print("dismiss")
			vc.dismissViewControllerAnimated(animated) {
				observer.onNext(from)
			}
		
			return AnonymousDisposable {}
		}
	}
	
	static func push(from: UINavigationController, vc: UIViewController, animated: Bool = true) -> ViewControllerAction {
		return Observable.create { observer in
		
			print("push")
			from.pushViewController(vc, animated: animated) {
				observer.onNext(from)
			}
		
			return AnonymousDisposable {}
		}
	}
	
	static func pop(from: UINavigationController, animated: Bool = true) -> ViewControllerAction {
		return Observable.create { observer in
		
			print("pop")
			from.popViewController(animated) {
				observer.onNext(from)
			}
		
			return AnonymousDisposable {}
		}
	}
	
	static func replace(from: UINavigationController, with: [UIViewController], animated: Bool = true) -> ViewControllerAction {
		return Observable.create { observer in
			print("replace")
			from.replaceViewControllers(with, animated: animated) {
				observer.onNext(from)
			}
		
			return AnonymousDisposable {}
		}
	}
}
