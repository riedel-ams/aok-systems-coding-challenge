import XCTest
import Combine
@testable import AOKSystemCodeChallenge

final class RepositoriesListViewModelTests: XCTestCase {
    
    func testFetchingSucceeds() {
        let input = [
            RepositoryDTO(id: 0, name: "ccc", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 0, name: "bbb", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 0, name: "aaa", description: "desc", stargazersCount: 123, createdAt: "11.22.33")
        ]
        let expectedResult = input.map { RepositoryItemViewModel(repositoryDto: $0) }
        let networkService = MockNetworkService(result: .success(input))
        let sut = RepositoriesListViewModel(apiClient: networkService, itemsPerPage: 10)
        
        sut.fetchNextRepositoriesListPage()
        
        waitUntil(
            sut.$repositoryViewModels,
            equals: expectedResult
        )
        
        XCTAssertTrue(sut.allLoaded)
    }
    
    func testFetchingWithPagination() {
        let input = [
            RepositoryDTO(id: 0, name: "ccc", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 1, name: "bbb", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 2, name: "aaa", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 3, name: "ccc", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 4, name: "bbb", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 5, name: "aaa", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 6, name: "ccc", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 7, name: "bbb", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 8, name: "aaa", description: "desc", stargazersCount: 123, createdAt: "11.22.33"),
            RepositoryDTO(id: 9, name: "ccc", description: "desc", stargazersCount: 123, createdAt: "11.22.33")
        ]
        
        let networkService = MockNetworkService(result: .success(input))
        let sut = RepositoriesListViewModel(apiClient: networkService, itemsPerPage: 4)
        
        sut.fetchNextRepositoriesListPage()
        waitUntil(
            sut.$repositoryViewModels,
            equals: input[0...3].map { RepositoryItemViewModel(repositoryDto: $0) }
        )
        
        sut.fetchNextRepositoriesListPage()
        waitUntil(
            sut.$repositoryViewModels,
            equals: input[0...7].map { RepositoryItemViewModel(repositoryDto: $0) }
        )
        
        sut.fetchNextRepositoriesListPage()
        waitUntil(
            sut.$repositoryViewModels,
            equals: input[0...9].map { RepositoryItemViewModel(repositoryDto: $0) }
        )
        
        XCTAssertTrue(sut.allLoaded)
    }
    
    func testFetchingDecodingError() {
        let inputResult = NetworkError.decodingFailed
        let expectedResult = NetworkError.decodingFailed.description
        
        let networkService = MockNetworkService(result: .failure(inputResult))
        let sut = RepositoriesListViewModel(apiClient: networkService, itemsPerPage: 10)
        
        sut.fetchNextRepositoriesListPage()
        
        waitUntil(
            sut.$errorDescription,
            equals: expectedResult
        )
    }
    
    func testFetchingInvalidURLError() {
        let inputResult = NetworkError.invalidURL
        let expectedResult = NetworkError.invalidURL.description
        
        let networkService = MockNetworkService(result: .failure(inputResult))
        let sut = RepositoriesListViewModel(apiClient: networkService, itemsPerPage: 10)
        
        sut.fetchNextRepositoriesListPage()
        
        waitUntil(
            sut.$errorDescription,
            equals: expectedResult
        )
    }
    
    func testFetchingRequestFailedError() {
        let inputResult = NetworkError.requestFailed(code: 123)
        let expectedResult = NetworkError.requestFailed(code: 123).description
        
        let networkService = MockNetworkService(result: .failure(inputResult))
        let sut = RepositoriesListViewModel(apiClient: networkService, itemsPerPage: 10)
        
        sut.fetchNextRepositoriesListPage()
        
        waitUntil(
            sut.$errorDescription,
            equals: expectedResult
        )
    }
}

fileprivate class MockNetworkService: GithubApiClientProtocol {
    
    private let result: Result<[RepositoryDTO], NetworkError>
    
    init(result: Result<[RepositoryDTO], NetworkError>) {
        self.result = result
    }
    
    func getRepositories(pageNumber: Int, itemsPerPage: Int) -> AnyPublisher<[RepositoryDTO], NetworkError> {
        if case .success(let dtos) = result, itemsPerPage < dtos.count {
            let pageIndex = pageNumber - 1
            let startIndex = pageIndex * itemsPerPage
            let endIndex = pageIndex * itemsPerPage + itemsPerPage
            
            var output: [RepositoryDTO]
            if endIndex <= dtos.count {
                output = Array(dtos[startIndex..<endIndex])
            } else {
                output = Array(dtos[startIndex..<(dtos.count)])
            }
            return Future { $0(.success(Array(output))) }.eraseToAnyPublisher()
        } else {
            return Future { $0(self.result) }.eraseToAnyPublisher()
        }
    }
}

