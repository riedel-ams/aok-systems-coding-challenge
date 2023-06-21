import SwiftUI

struct RepositoriesListView: View {
    
    @ObservedObject var viewModel: RepositoriesListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if let errorDescription = viewModel.errorDescription {
                    makeErrorView(description: errorDescription)
                } else if viewModel.repositoryViewModels.isEmpty {
                    ProgressView()
                } else {
                    mainScrollView
                }
            }
            .navigationTitle(viewModel.title)
        }
        .onAppear {
            viewModel.fetchNextRepositoriesListPage()
        }
    }
    
    private var mainScrollView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.repositoryViewModels, id: \.id) { itemViewModel in
                    RepositoriesListItemView(viewModel: itemViewModel)
                    Divider()
                }
                
                if !viewModel.allLoaded {
                    ProgressView()
                        .onAppear {
                            viewModel.fetchNextRepositoriesListPage()
                        }
                }
            }
            .padding()
        }
    }
    
    private func makeErrorView(description: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
                .foregroundColor(.red)
            Text(description)
        }
    }
}

struct RepositoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesListView(
            viewModel: RepositoriesListViewModel(
                apiClient: PreviewGithubApiClient(),
                itemsPerPage: 10
            )
        )
    }
}
