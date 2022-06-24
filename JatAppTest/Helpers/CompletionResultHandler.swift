//
//  CompletionResultHandler.swift
//  JatAppTest
//
//  Created by Michael Tseitlin on 23.06.2022.
//

import Foundation

typealias CompletionResultHandler<T> = (Result<T, Error>) -> Void
