import XCTest
import Combine
@testable import AOKSystemCodeChallenge

extension RepositoryItemViewModel: Equatable {
    public static func == (lhs: RepositoryItemViewModel, rhs: RepositoryItemViewModel) -> Bool {
        lhs.id == rhs.id
        &&
        lhs.name == rhs.name
        &&
        lhs.description == rhs.description
        &&
        lhs.starCountString == rhs.starCountString
        &&
        lhs.creationDateString == rhs.creationDateString
    }
}

extension XCTestCase {
    func waitUntil<T: Equatable>(
        _ propertyPublisher: Published<T>.Publisher,
        equals expectedValue: T,
        timeout: TimeInterval = 10
    ) {
        let expectation = expectation(
            description: "Awaiting value \(expectedValue)"
        )
        
        var cancellable: AnyCancellable?

        cancellable = propertyPublisher
            .first(where: { $0 == expectedValue })
            .sink { value in
                XCTAssertEqual(value, expectedValue)
                cancellable?.cancel()
                expectation.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)
    }
}
