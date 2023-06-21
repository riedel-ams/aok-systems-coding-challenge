import XCTest
@testable import AOKSystemCodeChallenge

final class RepositoryItemViewModelTests: XCTestCase {

    func testConvertDTOValues() {
        let input = RepositoryDTO(
            id: 123,
            name: "swift",
            description: "swift programming language",
            stargazersCount: 123,
            createdAt: "2016-08-04T00:52:15Z"
        )
        
        let expectedValues = (
            name: "swift",
            description: "swift programming language",
            stargazersCount: "123",
            createdAt: "2016-08-04"
        )
        
        let sut = RepositoryItemViewModel(repositoryDto: input)
        
        XCTAssertEqual(sut.name, expectedValues.name)
        XCTAssertEqual(sut.description, expectedValues.description)
        XCTAssertEqual(sut.starCountString, expectedValues.stargazersCount)
        XCTAssertEqual(sut.creationDateString, expectedValues.createdAt)
    }
    
    func testConvertDTOValuesUnreadableDate() {
        let input = RepositoryDTO(
            id: 123,
            name: "swift",
            description: "swift programming language",
            stargazersCount: 123,
            createdAt: "04.08.2016"
        )
        
        let sut = RepositoryItemViewModel(repositoryDto: input)
        
        XCTAssertEqual(sut.creationDateString, input.createdAt)
    }
}
