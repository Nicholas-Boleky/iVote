//
//  WireFrameVoteByIDView.swift
//  iVote
//
//  Created by Nick on 5/22/25.
//

import SwiftUI

struct WireFrameVoteByIDView: View {
    @EnvironmentObject var container: AppContainer
    
    @State private var poll: Poll?
    @State private var voteStatus: String?
    @State private var isLoading = false
    
    //Paste real poll ID here from CloudKit Dashboard or console
    private let hardcodedPollID = "262C430F-38B1-4063-A436-BBCB8E58113A"
    
    var body: some View {
        VStack(spacing: 20) {
            if let poll = poll {
                Text(poll.question)
                    .font(.headline)
                
                ForEach(poll.options) { option in
                    Button(option.text) {
                        Task { await vote(option: option, pollID: poll.id) }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                }
                
                if let voteStatus = voteStatus {
                    Text(voteStatus)
                        .foregroundColor(.green)
                }
                
                
            } else if isLoading {
                ProgressView("Fetching Poll...")
            } else {
                Button("Fetch Poll by ID") {
                    Task { await fetchPoll(by: hardcodedPollID) }
                }
            }
        }
        .padding()
    }
    
    private func fetchPoll(by id: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if let foundPoll = try await container.pollRepository.fetchPoll(byID: id) {
                await MainActor.run {
                    self.poll = foundPoll
                }
            } else {
                await MainActor.run {
                    voteStatus = "Poll not found."
                }
            }
        } catch {
            await MainActor.run {
                voteStatus = "Error fetching poll: \(error.localizedDescription)"
            }
        }
    }
    
    private func vote(option: PollOption, pollID: String) async {
        do {
            let user = try await container.userSessionRepository.getCurrentUser()
            let vote = Vote(id: UUID().uuidString,
                            pollID: pollID,
                            optionID: option.id,
                            userID: user.id,
                            timestamp: Date()
            )
            try await container.voteRepository.submitVote(vote)
            await MainActor.run {
                voteStatus = "Vote cast for \(option.text)"
            }
        } catch {
            await MainActor.run {
                voteStatus = "Error casting vote: \(error.localizedDescription)"
            }
        }
    }
}
