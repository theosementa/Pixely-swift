import Testing
@testable import Albums

@Test
func example2() async throws {
    let aValue = 4
    let bValue = 3
    let sum = aValue + bValue
    #expect(sum == 7)
}
