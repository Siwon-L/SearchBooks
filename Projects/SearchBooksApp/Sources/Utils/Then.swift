//
//  Then.swift
//  SearchBooksApp
//
//  Created by 이시원 on 2022/12/20.
//  Copyright © 2022 SearchBooks. All rights reserved.
//

import Foundation

protocol Then {}

extension Then where Self: AnyObject {
    @inlinable
    @discardableResult
    func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

extension NSObject: Then {}
