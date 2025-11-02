//
//  File.swift
//  Navigation
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI

extension Binding: @retroactive Equatable where Value: Equatable {
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
extension Binding: @retroactive Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.wrappedValue.hashValue)
    }
}
