import Foundation
import Combine

/// Error beim Ausführen der Requests
enum NetworkError: Error {
    
    /// Inkorrekte/korrupte URL
    case invalidURL
    
    /// Request Fehlgeschlagen mit Code
    case requestFailed(code: Int?)
    
    /// Decoding des JSONs fehlgeschlagen
    case decodingFailed
}

/// Macht Requests gegen die Github API
protocol GithubApiClientProtocol {
    
    /// Holt die Liste der Repositories als DTOs oder einen Error
    func getRepositories(
        pageNumber: Int,
        itemsPerPage: Int
    ) -> AnyPublisher<[RepositoryDTO], NetworkError>
}

class GithubApiClient: GithubApiClientProtocol {
    
    private enum Constants {
        static let repositoryOwner = "apple"
    }
    
    private enum Parameters {
        static func buildGetRepositoriesParameters(
            pageNumber: Int,
            itemsPerPage: Int
        ) -> [String: String] {
            [
                "type": "public",
                "sort": "name",
                "page": "\(pageNumber)",
                "per_page": "\(itemsPerPage)"
            ]
        }
    }
    
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: configuration)
    }
    
    func getRepositories(
        pageNumber: Int,
        itemsPerPage: Int
    ) -> AnyPublisher<[RepositoryDTO], NetworkError> {
        let endpoint = Endpoint.organizationRepositories(
            organizationName: Constants.repositoryOwner
        )
        
        return performRequest(
            urlString: endpoint.urlString,
            quieryParameters: Parameters.buildGetRepositoriesParameters(
                pageNumber: pageNumber,
                itemsPerPage: itemsPerPage
            )
        )
        .print()
        .eraseToAnyPublisher()
    }
    
    private func performRequest<T: Codable>(
        urlString: String,
        quieryParameters: [String: String]
    ) -> AnyPublisher<T, NetworkError> {
        guard var url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        url.append(
            queryItems: quieryParameters
                .map { URLQueryItem(name: $0.key, value: $0.value) }
        )
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.requestFailed(code: nil)
                }
                guard httpResponse.statusCode == 200 else {
                    throw NetworkError.requestFailed(code: httpResponse.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                print(error)
                return NetworkError.decodingFailed
            }
            .eraseToAnyPublisher()
    }
}

class PreviewGithubApiClient: GithubApiClientProtocol {
    
    func getRepositories(pageNumber: Int, itemsPerPage: Int) -> AnyPublisher<[RepositoryDTO], NetworkError> {
        Just(
            [
                RepositoryDTO(
                    id: 123,
                    name: "swift1",
                    description: "swift programming language",
                    stargazersCount: 12345,
                    createdAt: "12.34.56"
                )
                ,
                RepositoryDTO(
                    id: 234,
                    name: "swift2",
                    description: "swift programming language",
                    stargazersCount: 12345,
                    createdAt: "12.34.56"
                )
                ,
                RepositoryDTO(
                    id: 345,
                    name: "swift3",
                    description: "swift programming language",
                    stargazersCount: 12345,
                    createdAt: "12.34.56"
                ),
                RepositoryDTO(
                    id: 456,
                    name: "swift4",
                    description: "swift programming language",
                    stargazersCount: 12345,
                    createdAt: "12.34.56"
                )
            ]
        )
        .setFailureType(to: NetworkError.self)
        .eraseToAnyPublisher()
    }
}
