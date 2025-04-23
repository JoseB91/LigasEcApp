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
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image("ligasEc")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
                    .frame(height: geometry.size.height * 0.66)
                    .edgesIgnoringSafeArea(.top)
                
                VStack {
                    Spacer()
                        .frame(height: geometry.size.height * 0.60)
                    
                    VStack {
                        if leagueViewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            VStack(spacing: 16) {
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
                                            Spacer()
                                        }
                                        .padding(.vertical, 24)
                                    }
                                    .padding(.horizontal, 16)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(height: geometry.size.height * 0.40)
                    .task {
                        await leagueViewModel.loadLeagues()
                    }
                }
            }.background(Color(UIColor.systemGroupedBackground))
        }
    }
}

#Preview {
    let leagueViewModel = LeagueViewModel(leagueLoader: MockLeagueViewModel.mockLeagueLoader)
        
    LeagueView(leagueViewModel: leagueViewModel,
               navigationPath: .constant(NavigationPath()),
               imageView: MockImageView.mockImageView)
}
