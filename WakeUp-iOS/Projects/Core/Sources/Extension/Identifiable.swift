//
//  Identifiable.swift
//  Core
//
//  Created by 강현준 on 2023/08/31.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation

public protocol Identifiable {
    static var identifier: String { get }
}

public extension Identifiable {
    static var identifier: String { return "\(self))" }
}
