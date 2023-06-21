import Foundation

/// Die Endpunkte der Github API ab
enum Endpoint {
    
    private var baseUrl: String { "https://api.github.com" }
    
    /// Die Liste der Repositories für eine Organisation
    case organizationRepositories(organizationName: String)
    
    /// Die URL des Endpunktes als String
    var urlString: String {
        switch self {
        case .organizationRepositories(organizationName: let orgName):
            return baseUrl + "/orgs/" + orgName + "/repos"
        }
    }
}
