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
    
    let imageViewLoader: (URL, Table) -> ImageView
    
    var body: some View {
        VStack(spacing: 0) {
            Image("ligasEc")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height * 0.65)
            
            ZStack {
                if leagueViewModel.isLoading {
                    ProgressView("Loading leagues...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(spacing: 24) {
                        ForEach(leagueViewModel.leagues) { league in
                            Button {
                                    navigationPath.append(league)
                                } label: {
                                    ButtonView(url: league.logoURL,
                                               table: .league,
                                               text: league.name,
                                               imageViewLoader: imageViewLoader)
                                }
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .task {
            await leagueViewModel.loadIfNeeded()
        }
    }
}

#Preview {
    NavigationStack {
        let leagueViewModel = LeagueViewModel(repository: MockLeagueRepository())
        
        LeagueView(leagueViewModel: leagueViewModel,
                   navigationPath: .constant(NavigationPath()),
                   imageViewLoader: MockImageComposer().composeImageView)
    }
}
