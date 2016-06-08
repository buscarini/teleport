//
//  ViewController.swift
//  Teleport
//
//  Created by José Manuel on 06/08/2016.
//  Copyright (c) 2016 José Manuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		self.title = "VC1"
    }

	@IBAction func goto2(sender: AnyObject?) {
		let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
		delegate.navigate(
			.NavigationController(
				[
					.ViewController(ViewController2.self, child: nil),
					.ViewController(ViewController2.self, child: nil),
				]
			)
		)
	}
}


