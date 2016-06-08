//
//  AppDelegate.swift
//  Teleport
//
//  Created by José Manuel on 06/08/2016.
//  Copyright (c) 2016 José Manuel. All rights reserved.
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

