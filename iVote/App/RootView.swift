//
//  RootView.swift
//  iVote
//
//  Created by Nick on 5/13/25.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var container: AppContainer

    var body: some View {
        NavigationStack {
            switch appRouter.currentScreen {
            case .pollList:
                Text("Poll List Placeholder")
            case .pollCreation:
                CreatePollView(
                        viewModel: CreatePollViewModel(
                            pollRepository: container.pollRepository,
                            appRouter: appRouter
                        )
                    )
            case .lobby(let id):
                Text("Lobby Placeholder for poll \(id)")
            case .vote(let id):
                VoteByIDView()
            case .results(let id):
                Text("Results Placeholder for poll \(id)")
            case .wireframe:
                WireframeMainView()
            case .landingPage:
                LandingPageView()
            case .sharePoll(let id):
                SharePollView(pollID: id)
            }
        }
    }
}

#Preview {
    RootView()
        .environment(AppRouter())
}

