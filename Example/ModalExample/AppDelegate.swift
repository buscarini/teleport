//
//  AppDelegate.swift
//  ModalExample
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

import Teleport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

	var component: NavigationComponent!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		component = NavigationComponent(window: window!, initialState: .Empty)

        return true
    }

	func navigate(state: NavigationState) {
		component.state = state
	}
}


