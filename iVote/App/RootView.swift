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

    var body: some View {
        NavigationStack {
            switch appRouter.currentScreen {
            case .pollList:
                Text("Poll List Placeholder")
            case .pollCreation:
                Text("Poll Creation Placeholder")
            case .lobby(let id):
                Text("Lobby Placeholder for poll \(id)")
            case .vote(let id):
                Text("Vote Placeholder for poll \(id)")
            case .results(let id):
                Text("Results Placeholder for poll \(id)")
            }
        }
    }
}

#Preview {
    RootView()
}
