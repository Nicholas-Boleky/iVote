//
//  WireFrameVoteTallyView.swift
//  iVote
//
//  Created by Nick on 5/23/25.
//

import SwiftUI

struct WireFrameVoteTallyView: View {
    @EnvironmentObject var container: AppContainer
    
    //temporarily hardcoded poll id
    private let hardcodedPollID = "262C430F-38B1-4063-A436-BBCB8E58113A"
    
    @State private var poll: Poll?
    @State private var voteCounts: [String: Int] = [:]
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Button("Load Tally") {
                Task {
                    await loadPollAndTally()
                }
            }
            
            if let poll = poll {
                Text(poll.question)
                    .font(.headline)
                
                ForEach(poll.options) { option in
                    let count = voteCounts[option.id, default: 0]
                    Text("\(option.text) : \(count) votes")
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    private func loadPollAndTally() async {
        do {
            //first fetch poll, resolve option IDs
            guard let fetchedPoll = try await container.pollRepository.fetchPoll(byID: hardcodedPollID) else {
                await MainActor.run {
                    errorMessage = "Poll not found"
                }
                return
            }
            
            let counts = try await container.voteRepository.getVoteCounts(for: hardcodedPollID)
            
            await MainActor.run {
                self.poll = fetchedPoll
                self.voteCounts = counts
                self.errorMessage = nil
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Error loading tally: \(error.localizedDescription)"
            }
        }
    }
}
