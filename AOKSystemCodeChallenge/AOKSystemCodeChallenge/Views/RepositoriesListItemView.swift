import SwiftUI

struct RepositoriesListItemView: View {
    
    private let viewModel: RepositoryItemViewModel
    
    init(viewModel: RepositoryItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.name)
                .dynamicTypeSize(.xxxLarge)
                .foregroundColor(.blue)
                .fontWeight(.medium)
            
            if let description = viewModel.description {
                Text(description)
                    .dynamicTypeSize(.medium)
            }
            
            HStack {
                Text(viewModel.creationDateString)
                    .dynamicTypeSize(.xSmall)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(.orange)
                
                Text(viewModel.starCountString)
                    .dynamicTypeSize(.small)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct RepositoriesListItem_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesListItemView(
            viewModel:
                RepositoryItemViewModel(
                    repositoryDto: RepositoryDTO(
                        id: 123,
                        name: "swift",
                        description: "swift programming language",
                        stargazersCount: 12345,
                        createdAt: "12.34.56"
                    )
                )
        )
    }
}

