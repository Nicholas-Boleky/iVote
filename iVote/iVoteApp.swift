//
//  iVoteApp.swift
//  iVote
//
//  Created by Nick on 5/13/25.
//

import SwiftUI
import SwiftData

@main
struct iVoteApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    @StateObject private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appRouter)
        }
        .modelContainer(sharedModelContainer)
    }
}
