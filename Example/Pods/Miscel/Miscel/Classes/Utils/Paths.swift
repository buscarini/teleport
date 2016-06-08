//
//  Paths.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 28/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import Foundation

public struct PathUtils {
	public static func docsDirUrl() -> NSURL? {
		return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
	}
	
	public static func getFileName(id: String, pathExtension: String) -> String {
		return self.appendExtension(pathExtension)(fileName: self.escapeFileName(id))
	}
	
	public static func escapeFileName(string: String) -> String {
		let escapes = [ "/", "\\", "\n", ":" , "?", "&", "=" ]
		return escapes.reduce(string) {
			string, escape in
			return string.stringByReplacingOccurrencesOfString(escape, withString: "")
		}
	}
	
	public static func appendExtension(pathExtension: String) -> (fileName: String) -> String {
		return { fileName in
			let url = NSURL(fileURLWithPath: fileName)
			if url.pathExtension != nil {
				return fileName
			}
			else {
				return url.URLByAppendingPathExtension(pathExtension).path ?? fileName
			}
		}
	}
}

