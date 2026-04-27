//
//  TeamView.swift
//  LigasEcApp
//
//  Created by José Briones on 25/2/25.
//

import SwiftUI

struct TeamView: View {
    @StateObject private var teamViewModel: TeamViewModel
    @Binding var navigationPath: NavigationPath
    let imageViewLoader: (URL, Table) -> ImageView
    let title: String

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]

    init(teamViewModel: TeamViewModel,
         navigationPath: Binding<NavigationPath>,
         imageViewLoader: @escaping (URL, Table) -> ImageView,
         title: String) {
        _teamViewModel = StateObject(wrappedValue: teamViewModel)
        _navigationPath = navigationPath
        self.imageViewLoader = imageViewLoader
        self.title = title
    }

    var body: some View {
        ScrollView {
            if teamViewModel.isSerieBComingSoon {
                ComingSoonView()
                    .padding(.horizontal, 20)
                    .padding(.top, 48)
            } else if teamViewModel.isLoading {
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
            await teamViewModel.loadIfNeeded()
        }
        .withErrorAlert(errorModel: $teamViewModel.errorModel)
    }
}

// MARK: - Card Views

struct TeamCardView: View {
    let team: Team
    let imageViewLoader: (URL, Table) -> ImageView

    var body: some View {
        VStack(spacing: 8) {
            imageViewLoader(team.logoURL, .team)
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                .accessibilityLabel(team.name)
            Text(team.name)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, minHeight: 118)
        .padding(.horizontal, 6)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }
}

struct ComingSoonView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.exclamationmark")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text(Constants.comingSoon)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text(Constants.serieBComingSoonMessage)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Constants.serieBComingSoonMessage)
    }
}

// Placeholder Card with Shimmer Effect
struct TeamCardPlaceholderView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 72, height: 72)
                .shimmering(active: true)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.25))
                .frame(width: 72, height: 14)
                .shimmering(active: true)
        }
        .frame(maxWidth: .infinity, minHeight: 118)
        .padding(.horizontal, 6)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
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
        let league = League(id: "IaFDigtm",
                            name: "LigaPro Serie A",
                            logoURL: URL(string: "https://www.flashscore.com/res/image/data/v3G098ld-veKf2ye0.png")!,
                            dataSource: .flashLive)
        let teamViewModel = TeamViewModel(repository: MockTeamRepository(), league: league)

        TeamView(teamViewModel: teamViewModel,
                 navigationPath: .constant(NavigationPath()),
                 imageViewLoader: MockImageComposer().composeImageView,
                 title: league.name)
    }
}
