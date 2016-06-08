//
//  Either.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 31/5/16.
//
//

import Foundation

public enum Either<T, ErrorT> {
	case Left(ErrorT)
	case Right(T)
}

// MARK: Monad
extension Either {
	public func map<U>(_ f:(T)->(U)) -> Either<U, ErrorT> {
		switch self {
			case .Left(let error):
				return Either<U, ErrorT>.Left(error)
			
			case .Right(let value):
				return Either<U, ErrorT>.Right(f(value))
		}
	}
	
	public func mapError<ErrorU>(_ f:(ErrorT)->(ErrorU)) -> Either<T, ErrorU> {
		switch self {
			case .Left(let error):
				return Either<T, ErrorU>.Left(f(error))
			
			case .Right(let value):
				return Either<T, ErrorU>.Right(value)
		}
	}
	
	public func flatMap<U>(_ f:(T)->(Either<U, ErrorT>)) -> Either<U, ErrorT> {
		switch self {
			case .Left(let error):
				return Either<U, ErrorT>.Left(error)
			
			case .Right(let value):
				return f(value)
		}
	}
}

