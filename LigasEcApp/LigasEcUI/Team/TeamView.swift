//
//  TeamView.swift
//  LigasEcApp
//
//  Created by José Briones on 25/2/25.
//

import SwiftUI

struct TeamView: View {
    @State var teamViewModel: TeamViewModel
    @Binding var navigationPath: NavigationPath
    let imageViewLoader: (URL, Table) -> ImageView
    let title: String

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            if teamViewModel.isLoading {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<8, id: \.self) { _ in
                        TeamCardPlaceholderView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(teamViewModel.teams) { team in
                        Button {
                            navigationPath.append(team)
                        } label: {
                            TeamCardView(team: team, imageViewLoader: imageViewLoader)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel(String(localized: "SELECT_TEAM", defaultValue: "Select \(team.name) team"))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
            }
        }
        .navigationTitle(title)
        .toolbarTitleDisplayMode(.large)
        .refreshable {
            await teamViewModel.loadTeams()
        }
        .task {
            await teamViewModel.loadTeams()
        }
        .withErrorAlert(errorModel: $teamViewModel.errorModel)
    }
}

// MARK: - Card Views

struct TeamCardView: View {
    let team: Team
    let imageViewLoader: (URL, Table) -> ImageView

    var body: some View {
        VStack(spacing: 12) {
            imageViewLoader(team.logoURL, .team)
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
                .accessibilityLabel(team.name)
            Text(team.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}

// Placeholder Card with Shimmer Effect
struct TeamCardPlaceholderView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 96, height: 96)
                .shimmering(active: true)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.25))
                .frame(width: 80, height: 16)
                .shimmering(active: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .opacity(0.85)
    }
}

// MARK: - Shimmer Modifier
extension View {
    func shimmering(active: Bool) -> some View {
        modifier(ShimmerModifier(isActive: active))
    }
}

struct ShimmerModifier: ViewModifier {
    var isActive: Bool

    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .rotationEffect(.degrees(30))
                    .offset(x: phase)
                    .animation(
                        Animation.linear(duration: 1.0)
                            .repeatForever(autoreverses: false),
                        value: phase
                    )
                )
                .onAppear {
                    self.phase = 150
                }
        } else {
            content
        }
    }
}


// MARK: - Preview

#Preview {
    NavigationStack {
        let teamViewModel = TeamViewModel(repository: MockTeamRepository())
        
        TeamView(teamViewModel: teamViewModel,
                 navigationPath: .constant(NavigationPath()),
                 imageViewLoader: MockImageComposer().composeImageView,
                 title: "LigaPro Serie A")
    }
}
