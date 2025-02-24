//
//  LigasEcApp.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import SwiftUI
import Combine
import LigasEcAPI
import SharedAPI

@main
struct LigasEcApp: App {
        
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(leagueViewModel: makeLeagueViewModel())
            }
        }
    }
    
    private func makeLeagueViewModel() -> LeagueViewModel {
        let baseURL = URL(string: "https://v3.football.api-sports.io")!
        let httpClient = URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral),
            apiKey: "c3f7e1d18170e13fe81a3a865b4cf1b3")
        
        let leagueLoader: () -> AnyPublisher<[League], Error> = {
            let url = LeagueEndpoint.get(country: "Ecuador", season: "2023" ).url(baseURL: baseURL)
            
            return httpClient
                .getPublisher(url: url)
                .tryMap(LeagueMapper.map)
                .eraseToAnyPublisher()
        }
        
        return LeagueViewModel(leagueLoader: leagueLoader)
    }
}

//struct User: Identifiable, Decodable {
//    let id: Int
//    let name: String
//}
//
//import SwiftUI
//
//@MainActor
//class UserViewModel: ObservableObject {
//    @Published var users: [User] = []
//    
//    func fetchUsers() async {
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            users = try JSONDecoder().decode([User].self, from: data)
//        } catch {
//            print("Error fetching users: \(error)")
//        }
//    }
//}
//
//struct UserListView: View {
//    @StateObject var viewModel = UserViewModel()
//    
//    var body: some View {
//        NavigationView {
//            List(viewModel.users) { user in
//                Text(user.name)
//            }
//            .navigationTitle("Users")
//            .task { await viewModel.fetchUsers() } // Auto-fetch on appear
//        }
//    }
//}
