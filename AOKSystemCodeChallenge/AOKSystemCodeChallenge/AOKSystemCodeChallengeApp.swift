import SwiftUI

@main
struct AOKSystemCodeChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            RepositoriesListView(
                viewModel: RepositoriesListViewModel(
                    apiClient: GithubApiClient()
                )
            )
        }
    }
}
