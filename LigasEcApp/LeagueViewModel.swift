//
//  LeagueViewModel.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import Foundation
import Combine
import LigasEcAPI
import SharedAPI

final class LeagueViewModel: ObservableObject {
    
    private var cancellable: Cancellable?
    private let leagueLoader: () -> AnyPublisher<[League], Error>
    @Published var leagues = [League]()
    
    init(leagueLoader: @escaping () -> AnyPublisher<[League], Error>) {
        self.leagueLoader = leagueLoader
    }
    
    var title: String {
        String(localized: "LEAGUE_VIEW_TITLE",
               table: "League",
               bundle: Bundle(for: Self.self))
    }
    
    func loadLeagues() {
       // guard !isLoading else { return }
        
        //presenter?.didStartLoading()
        //isLoading = true
        
        cancellable = leagueLoader()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCancel: { [weak self] in
                //self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                        
                    case let .failure(error): break
                        //self?.presenter?.didFinishLoading(with: error)
                    }
                    
                    //self?.isLoading = false
                }, receiveValue: { [weak self] leagues in
                    self?.leagues = leagues
                })
    }
}


public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func getPublisher(url: URL) -> Publisher {        
        return Deferred {
            Future { promise in
                Task {
                    do {
                        let result = try await self.get(from: url)
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        //.handleEvents(receiveCancel: { task?.cancel() }) //TODO: Implement this
        .eraseToAnyPublisher()
    }
}


