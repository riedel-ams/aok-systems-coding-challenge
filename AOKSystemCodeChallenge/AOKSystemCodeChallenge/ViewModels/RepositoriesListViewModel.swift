import Combine
import SwiftUI

extension NetworkError {
    
    /// Beschreibung des NetworkErrors
    var description: String {
        switch self {
        case .invalidURL:
            return "Inkorrekte URL"
        case .decodingFailed:
            return "JSON konnte nicht dekodiert werden."
        case .requestFailed(let code):
            if let code = code {
                return "Request fehlgeschlagen mit Code: \(code)"
            } else {
                return "Request fehlgeschlagen."
            }
        }
    }
}

/// ViewModel, welches Liste der Repositories fetcht und die Liste der Titel
class RepositoriesListViewModel: ObservableObject {
    
    /// ViewModels für die Repository-Kacheln
    @Published private(set) var repositoryViewModels: [RepositoryItemViewModel] = []
    
    /// Beschreibung eines Errors, wenn denn einer aufgetreten ist
    @Published private(set) var errorDescription: String?
    
    /// `true`, wenn alle Repositories geladen wurden.
    var allLoaded = false
    
    /// Überschrift für die View
    let title = "Apple Repositories"
    
    private let apiClient: GithubApiClientProtocol
    private let itemsPerPage: Int
    private var pageNumber = 1
    private var isLoading: Bool = false
    private var cancelBag: [AnyCancellable] = []
    
    init(
        apiClient: GithubApiClientProtocol,
        itemsPerPage: Int = Constants.itemsPerPage
    ) {
        self.apiClient = apiClient
        self.itemsPerPage = itemsPerPage
    }
    
    /// Holt die Liste der Repositories
    func fetchNextRepositoriesListPage() {
        guard !isLoading, !allLoaded else { return }
        
        isLoading = true
        
        apiClient.getRepositories(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
            .map(convertRepositoryDTOs)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    self?.pageNumber += 1
                case .failure(let error):
                    self?.errorDescription = error.description
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { fatalError() }
                if self.itemsPerPage > value.count {
                    self.allLoaded = true
                }
                self.repositoryViewModels.append(contentsOf: value)
            })
            .store(in: &cancelBag)
    }
    
    private func convertRepositoryDTOs(_ dtos: [RepositoryDTO]) -> [RepositoryItemViewModel] {
        return dtos.map { RepositoryItemViewModel(repositoryDto: $0) }
    }
}
