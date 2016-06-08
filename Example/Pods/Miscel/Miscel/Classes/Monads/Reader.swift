//
//  Reader.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 18/5/16.
//
//

import Foundation

public struct Reader<Env,A> {
	public let runReader: (Env) -> (A)
	
	public init(runReader: (Env) -> (A)) {
		self.runReader = runReader
	}
	
	public static func of(value: A) -> Reader {
		return Reader { (_ : Env) -> A in
			return value
		}
	}
	
	public func run(config : Env) -> A {
		return self.runReader(config)
	}
	
	public func flatMap<B>(f: (A) -> Reader<Env,B>) -> Reader<Env,B> {
		return Reader<Env,B> { config in
			return f(self.run(config)).run(config)
		}
	}
	
	public func map<B>(f: (A) -> (B)) -> Reader<Env,B> {
		return Reader<Env,B> { config in
			return f(self.run(config))
		}
	}
	
	
	public static func ask() -> Reader<Env,Env> {
		return Reader<Env,Env> { $0 }
	}
}

