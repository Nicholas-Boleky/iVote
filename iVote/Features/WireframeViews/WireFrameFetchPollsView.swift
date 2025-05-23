//
//  WireFrameFetchPollsView.swift
//  iVote
//
//  Created by Nick on 5/22/25.
//

import SwiftUI

///A simple view to fetch and print polls from CloudKit using PollRepository
struct WireFrameFetchPollsView: View {
    @EnvironmentObject var container: AppContainer
    @State private var polls: [Poll] = []
    @State private var errorMesage: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Button("Fetch Polls") {
                Task {
                    await fetchPolls()
                }
            }
            
            if let errorMesage {
                Text(errorMesage)
                    .foregroundStyle(.red)
            }
            
            if !polls.isEmpty {
                List(polls) { poll in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(poll.question)
                            .font(.headline)
                        ForEach(poll.options) { option in
                            Text(option.text)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private func fetchPolls() async {
        do {
            let results = try await container.pollRepository.fetchPolls()
            await MainActor.run {
                self.polls = results
                self.errorMesage = nil
                print("✅ Retrieved \(results.count) polls")
                results.forEach { print("Poll: \($0.question) [\($0.options.map(\.text).joined(separator: ", "))]") }
            }
        } catch {
            await MainActor.run {
                self.errorMesage = "Error fetching polls: \(error.localizedDescription)"
                print("Error fetching polls: \(error.localizedDescription)")
            }
        }
    }
}
