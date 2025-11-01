//
//  PixelyTests.swift
//  PixelyTests
//
//  Created by Theo Sementa on 01/11/2025.
//

import Testing

struct PixelyTests {

    @Test
    func example() async throws {
        let aValue = 4
        let bValue = 3
        let sum = aValue + bValue
        #expect(sum == 7)
    }

}
