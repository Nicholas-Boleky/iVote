//
//  VoteRepository.swift
//  iVote
//
//  Created by Nick on 5/14/25.
//

import Foundation

/// A repository for submitting and retrieving votes in a poll-based system.
///
/// This protocol abstracts backend operations like casting a vote,
/// tallying results, and optionally observing live changes.
/// Designed for backend flexibility (e.g., CloudKit, Firebase).
protocol VoteRepository {
    
    /// Submits a user's vote for a specific poll option.
        ///
        /// Backend implementations may enforce constraints such as one vote per user per poll.
        /// - Parameter vote: The `Vote` object to submit.
        /// - Throws: An error if the vote could not be submitted, such as a network issue or a double-vote conflict.
    func submitVote(_ vote: Vote) async throws
    
    /// Retrieves a dictionary of current vote counts for a given poll.
    ///
    /// Keys represent `optionID`s, and values represent the number of votes received.
    /// - Parameter pollID: The unique identifier of the poll.
    /// - Returns: A mapping of option IDs to their current vote counts.
    /// - Throws: An error if the counts could not be retrieved.
    func getVoteCounts(for PollID: String) async throws -> [String: Int]
    
    /// Returns a stream of live votes submitted for a given poll.
        ///
        /// This is useful for implementing real-time vote tracking (e.g., a live lobby or results view).
        /// The backend implementation may use CloudKit subscriptions, polling, or WebSockets.
        /// - Parameter pollID: The ID of the poll to observe.
        /// - Returns: An `AsyncStream` that yields `Vote` objects as they are submitted.
    func observeVotes(for PollID: String) -> AsyncStream<Vote>
}
