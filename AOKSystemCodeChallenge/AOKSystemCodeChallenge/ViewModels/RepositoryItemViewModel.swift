import Foundation

/// ViewModel für die Details eines Repositories
struct RepositoryItemViewModel: Identifiable {
    
    var id: Int {
        repositoryDto.id
    }
    
    /// Name des Repositories
    var name: String {
        repositoryDto.name
    }
    
    /// Beschreibung  des Repositories
    var description: String? {
        repositoryDto.description
    }
    
    /// Erstellungsdatum des Repositories als String
    var creationDateString: String {
        tryConvertDateString(repositoryDto.createdAt)
    }
    
    /// Anzahl der Sterne  des Repositoriesals String
    var starCountString: String {
        "\(repositoryDto.stargazersCount)"
    }
    
    private let repositoryDto: RepositoryDTO
    
    init(repositoryDto: RepositoryDTO) {
        self.repositoryDto = repositoryDto
    }
    
    private func tryConvertDateString(_ dateString: String) -> String {
        if let date = dateString.toDate {
            return date.toString
        } else {
            return dateString
        }
    }
}

fileprivate extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)
    }
}

fileprivate extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
