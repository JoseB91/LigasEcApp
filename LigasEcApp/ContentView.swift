//
//  ContentView.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var leagueViewModel: LeagueViewModel
    
    var body: some View {
        List(leagueViewModel.leagues) { league in
            Text(league.name)
                .font(.headline)
        }
        .navigationTitle(leagueViewModel.title)
        .toolbarTitleDisplayMode(.inline)
        .onAppear {
            leagueViewModel.loadLeagues()
        }
    }
}

//struct LeagueView: View {
//    @Binding var leagues: [League]
//    
//    var body: some View {
//        List {
//            ForEach(leagueViewModel.leagues) { league in
//                VStack {
//                    Text(league.name)
//                        .font(.headline)
//                }
//            }
//        }
//        .navigationTitle(leagueViewModel.title)
////        .onAppear {
////            leagueViewModel.loadLeagues()
////        }
//    }
//}

#Preview {
    //ContentView(leagueViewModel: )
}
