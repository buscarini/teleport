//
//  NSAttributedString+Utils.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

extension NSAttributedString {

	 public func trimmed(set: NSCharacterSet) -> NSAttributedString {
		let result = self.mutableCopy()
	
        // Trim leading characters from character set.
		while true {
			let range = (result.string as NSString).rangeOfCharacterFromSet(set)
			
			guard range.length != 0 && range.location == 0 else {
				break
			}
			
			result.replaceCharactersInRange(range, withString: "")
		}

        // Trim trailing characters from character set.
		while true {
			let range = (result.string as NSString).rangeOfCharacterFromSet(set, options: .BackwardsSearch)
			
			guard range.length != 0 && NSMaxRange(range) == result.length else {
				break
			}
			
			result.replaceCharactersInRange(range, withString: "")
		}
		
		return result as! NSAttributedString
    }
}

public func +(left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
	let result = NSMutableAttributedString()
	
	result.appendAttributedString(left)
	result.appendAttributedString(right)
	
	return result
}

