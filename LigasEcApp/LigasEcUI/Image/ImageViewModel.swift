//
//  ImageViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import SwiftUI

@Observable
final class ImageViewModel {
    private let repository: ImageRepository
    
    var isLoading = false
    var data: Data?
        
    init(repository: ImageRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadImage() async {
       
        isLoading = true
        defer { isLoading = false }
        
        data = try? await repository.loadImage()
    }
}

struct MockImageRepository: ImageRepository {
    func loadImage() async throws -> Data {
        Data()
    }
}

struct MockImageComposer {
    func composeImageView(with url: URL, on table: Table) -> ImageView {
        let mockRepository = MockImageRepository()
        let mockViewModel = ImageViewModel(repository: mockRepository)
        return ImageView(imageViewModel: mockViewModel)
    }
}

extension Image {
    static func load(from data: Data?, fallback: String = "photo") -> Image {
        guard let data, let uiImage = UIImage(data: data) else {
            return Image(systemName: fallback)
        }
        return Image(uiImage: uiImage)
    }
}
