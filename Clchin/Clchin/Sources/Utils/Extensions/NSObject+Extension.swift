//
//  NSObject+Extension.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit

protocol IdentifierProtocol {
    static var identifier: String { get }
}

extension NSObject: IdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
