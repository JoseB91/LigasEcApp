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
        VStack{
            Spacer()
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
            //.navigationTitle(leagueViewModel.title)
            //.toolbarTitleDisplayMode(.large)
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text(leagueViewModel.title)
//                        .font(.system(size: 36, weight: .bold))
//                }
//            }
            .navigationBarTitleDisplayMode(.inline) // We'll use inline mode
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(leagueViewModel.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
            }
            // To simulate the large title behavior with scrolling
            .padding(.top)
            .listRowSeparator(.hidden)
            .listRowSpacing(24)
            .listStyle(.insetGrouped)
            .task {
                await leagueViewModel.loadLeagues()
            }
            .frame(height: CGFloat(leagueViewModel.leagues.count * 150))
//            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            Spacer()
        }.background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    let leagueViewModel = LeagueViewModel(leagueLoader: MockLeagueViewModel.mockLeagueLoader)
        
    LeagueView(leagueViewModel: leagueViewModel,
               navigationPath: .constant(NavigationPath()),
               imageView: MockImageView.mockImageView)
}
