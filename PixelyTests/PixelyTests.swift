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
        let a = 4
        let b = 3
        let sum = a + b
        #expect(sum == 7)
    }

}
