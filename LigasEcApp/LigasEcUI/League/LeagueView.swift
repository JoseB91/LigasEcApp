//
//  LeagueView.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import SwiftUI
import LigasEcAPI
import SharedAPI

struct LeagueView: View {
    @ObservedObject var leagueViewModel: LeagueViewModel
    @Binding var navigationPath: NavigationPath
    
    let imageView: (URL, Table) -> ImageView
        
    var body: some View {
//        VStack{
//            Spacer()
            List {
                if leagueViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(leagueViewModel.leagues) { league in
                        Button {
                            navigationPath.append(league)
                        } label: {
                            HStack {
                                imageView(league.logoURL, Table.League)
                                    .frame(width: 96, height: 48)
                                Text(league.name)
                                    .font(.title)
                                    .foregroundColor(.primary)
                            }
                        }
                        .tint(.black)
                        .frame(height: 80)
                    }
                }
            }
            .navigationTitle(leagueViewModel.title)
            .toolbarTitleDisplayMode(.large)
            .listRowSeparator(.hidden)
            .listRowSpacing(24)
            .listStyle(.insetGrouped)
            .task {
                await leagueViewModel.loadLeagues()
            }
//            .frame(height: CGFloat(leagueViewModel.leagues.count * 150))
//            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            
//            Spacer()
//        }.background(Color(UIColor.systemGroupedBackground))
    }

}

#Preview {
    let leagueViewModel = LeagueViewModel(leagueLoader: MockLeagueViewModel.mockLeagueLoader)
        
    LeagueView(leagueViewModel: leagueViewModel,
               navigationPath: .constant(NavigationPath()),
               imageView: MockImageView.mockImageView)
}
