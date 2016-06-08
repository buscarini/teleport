//
//  String.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 11/11/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

public extension String {

	public static func length(string: String) -> Int {
		return string.characters.count
	}

	public static func empty(string: String) -> Bool {
		return self.length(string) == 0
	}
	
	public static func isBlank(string: String?) -> Bool {
		guard let string = string else { return true }
	
		return trimmed(string).characters.count == 0
	}
	
	public static func trimmed(string: String) -> String {
		return string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}
	
	public static func joined(components: [String?], separator: String = "\n") -> String {
		return components.flatMap {$0}
				.filter(not(isBlank))
				.joinWithSeparator(separator)
	}
	
	public static func plainString(htmlString: String) -> String {
		return htmlString.stringWithBRsAsNewLines().stringByConvertingHTMLToPlainText()
	}
	
	public static func localize(string: String) -> String {
		return string.localized()
	}
	
	public func localized() -> String {
		return NSLocalizedString(self, comment: "")
	}
	
	public static func wholeRange(string: String) -> Range<Index> {
		return string.startIndex..<string.endIndex
	}
	
	public static func words(string: String) -> [String] {
		var results : [String] = []
		string.enumerateLinguisticTagsInRange(self.wholeRange(string), scheme: NSLinguisticTagWord, options: [], orthography: nil) {
			(tag, tokenRange, sentenceRange,_) in
			results.append(string.substringWithRange(tokenRange))
		}
		
		return results
	}
}
