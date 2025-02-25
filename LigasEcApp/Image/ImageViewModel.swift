//
//  ImageViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 25/2/25.
//

import UIKit
import Combine

final class ImageViewModel<Image>: ObservableObject {
    let imageURL : URL
    let imageLoader: () async throws -> Data
    let imageTransformer: (Data) -> Image?
    
    @Published var isLoading = false
    @Published var image: UIImage = UIImage.init()
    
    init(imageURL: URL, imageLoader: @escaping () async throws -> Data, imageTransformer: @escaping (Data) -> Image?) {
        self.imageURL = imageURL
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    
    @MainActor
    func loadImage() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let dataImage = try await imageLoader()
            image = try UIImage.tryMake(data: dataImage)
        } catch {
            image = UIImage()
            // TODO: Handle this
            //errorMessage = ErrorModel(message: "Failed to load leagues: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
}

extension UIImage {
    struct InvalidImageData: Error {}
    
    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }
        return image
    }
}
