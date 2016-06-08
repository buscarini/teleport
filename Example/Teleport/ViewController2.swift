//
//  ViewController2.swift
//  Teleport
//
//  Created by José Manuel Sánchez Peñarroja on 8/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		self.title = "VC2"
    }

	@IBAction func goto1(sender: AnyObject?) {
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		delegate.navigate(
			.NavigationController(
				[
					.ViewController(ViewController.self, child: nil)
				]
			)
		)
	}
}


