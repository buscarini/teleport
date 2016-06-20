//
//  ViewController2.swift
//  Teleport
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

import Teleport

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		self.title = "VC2"
    }

	@IBAction func goto1(sender: AnyObject?) {
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
//		delegate.navigate(
//			.ViewController(ViewController.self, child: nil)
//		)

		
		delegate.navigate(
			ViewController2.tabNavigation()
		)
	}
	
	static func tabNavigation() -> NavigationState {
		return .TabBar([
			.NavigationController([.ViewController(ViewController.self, child: nil)]),
			.NavigationController([.ViewController(ViewController2.self, child: nil)])
			],
			selected: 0
		)
	}
}


