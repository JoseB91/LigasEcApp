//
//  ImageViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 12/3/25.
//

import UIKit

@Observable
final class ImageViewModel<Image> {
    let imageLoader: () async throws -> Data
    let imageTransformer: (Data) -> Image?
    
    var isLoading = false
    var image: UIImage = UIImage.init()
    
    init(imageLoader: @escaping () async throws -> Data, imageTransformer: @escaping (Data) -> Image?) {
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
            image = UIImage(systemName: "soccerball") ?? UIImage()
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
