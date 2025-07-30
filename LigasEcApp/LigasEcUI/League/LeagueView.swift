//
//  LeagueView.swift
//  LigasEcApp
//
//  Created by José Briones on 24/2/25.
//

import SwiftUI

struct LeagueView: View {
    var leagueViewModel: LeagueViewModel
    @Binding var navigationPath: NavigationPath
    @State private var hasLoaded = false
    
    let imageView: (URL, Table) -> ImageView
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image("ligasEc")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .frame(height: geometry.size.height * 0.80)
                    .edgesIgnoringSafeArea(.top)
                
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height * 0.70)
                    
                    VStack {
                        if leagueViewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            List(leagueViewModel.leagues) { league in
                                Button {
                                    navigationPath.append(league)
                                } label: {
                                    HStack {
                                        imageView(league.logoURL, Table.League)
                                            .frame(width: 96, height: 48)
                                        Text(league.name)
                                            .font(.title)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                                .cornerRadius(10)
                            }
                            .listRowSpacing(24)
                        }
                    }
                    .frame(height: geometry.size.height * 0.30)
                    .onAppear {
                        if !hasLoaded {
                            hasLoaded = true
                            Task {
                                await leagueViewModel.loadLeagues()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let leagueViewModel = LeagueViewModel(leagueLoader: MockLeagueViewModel.mockLeagueLoader)
    
    LeagueView(leagueViewModel: leagueViewModel,
               navigationPath: .constant(NavigationPath()),
               imageView: MockImageView.mockImageView)
}
