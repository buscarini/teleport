//
//  TableView.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 29/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

public extension UITableView {
	public func hideSeparatorsForEmptyRows() {
		self.tableFooterView = UIView()
		self.tableFooterView?.backgroundColor = UIColor.clearColor()
	}
}

