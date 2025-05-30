//
//  WireFrameCreatePollView.swift
//  iVote
//
//  Created by Nick on 5/20/25.
//

import Foundation
import SwiftUI
import CloudKit

/// A simple test view to create a hardcoded poll and verify CloudKit write functionality
struct WireFrameCreatePollView: View {
    @EnvironmentObject var container: AppContainer
    @State private var message: String?

    var body: some View {
        VStack(spacing: 16) {
            Button("Create Dummy Poll") {
                Task {
                    await createPoll()
                }
            }

            if let message = message {
                Text(message)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .task {
            do {
                let status = try await CKContainer(identifier: "iCloud.iVote").accountStatus()
                switch status {
                case .available:
                    print("iCloud available")
                case .noAccount:
                    print("No iCloud account")
                case .restricted:
                    print("iCloud restricted")
                case .couldNotDetermine:
                    print("Could not determine iCloud status")
                @unknown default:
                    print("Unknown iCloud status")
                }
            } catch {
                print("Failed to get account status: \(error.localizedDescription)")
            }
        }
    }

    /// Creates a static poll for testing and uploads it to CloudKit.
    private func createPoll() async {
        let poll = Poll(
            id: UUID().uuidString,
            type: .multipleChoice,
            question: "What’s your favorite fruit?",
            options: [
                PollOption(id: UUID().uuidString, text: "Apple"),
                PollOption(id: UUID().uuidString, text: "Banana"),
                PollOption(id: UUID().uuidString, text: "Grape")
            ],
            createdAt: Date(),
            expiresAt: nil
        )

        do {
            try await container.pollRepository.createPoll(poll)
            await MainActor.run {
                message = "Poll created successfully!"
            }
        } catch {
            await MainActor.run {
                message = "Error!: \(error.localizedDescription)"
            }
        }
    }
}
