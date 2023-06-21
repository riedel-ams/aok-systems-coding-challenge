import Foundation

/// Bildet eine der geladenen Repositories ab
struct RepositoryDTO: Codable {
    
    /// ID
    let id: Int
    
    /// Name des Repositories
    let name: String
    
    /// Beschreibung
    let description: String?
    
    /// Anzahl der Favoriten
    let stargazersCount: Int
    
    /// Erstellungsdatum als String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case stargazersCount = "stargazers_count"
        case createdAt = "created_at"
    }
}
