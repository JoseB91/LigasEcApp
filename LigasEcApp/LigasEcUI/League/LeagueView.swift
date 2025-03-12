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
    @StateObject var leagueViewModel: LeagueViewModel
    @Binding var navigationPath: NavigationPath
    
    let imageView: (URL, Table) -> ImageView
        
    var body: some View {
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
                                .font(.title2)
                        }
                    }.tint(.black)
                }
            }
        }
        .listRowSeparator(.hidden)
        .listRowSpacing(12)
        .listStyle(.insetGrouped)
        .navigationTitle(leagueViewModel.title)
        .toolbarTitleDisplayMode(.inline)
        .refreshable {
            await leagueViewModel.loadLeagues()
        }
        .task {
            await leagueViewModel.loadLeagues()
        }
        .alert(item: $leagueViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    let leagueViewModel = LeagueViewModel(leagueLoader: MockLeagueViewModel.mockLeagueLoader)
    
    let imageLoader = {
        Data()
    }
    let imageViewModel = ImageViewModel(imageLoader: imageLoader,
                                        imageTransformer: UIImage.init)
    
    LeagueView(leagueViewModel: leagueViewModel,
               navigationPath: .constant(NavigationPath()),
               imageView: MockImageView.mockImageView)
}
