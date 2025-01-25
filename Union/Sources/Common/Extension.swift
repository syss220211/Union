//
//  Extension.swift
//  Union
//
//  Created by 박서연 on 1/25/25.
//

import Foundation

public extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        return dictionary as? [String: Any] ?? [:]
    }
}
