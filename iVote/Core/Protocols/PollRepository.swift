//
//  PollRepository.swift
//  iVote
//
//  Created by Nick on 5/14/25.
//

import Foundation

/// A repository for managing poll data, abstracting the underlying storage mechanism (e.g., CloudKit, Firebase).
protocol PollRepository {
    
    /// Fetches all available polls.
    ///
    /// This may include active, expired, or scheduled polls depending on implementation.
    /// - Returns: An array of `Poll` objects.
    /// - Throws: A repository-specific error if fetching fails.
    func fetchPolls() async throws -> [Poll]
    
    /// Creates a new poll and persists it to the backend.
        ///
        /// The repository implementation may auto-generate the poll's `id` if not provided.
        /// - Parameter poll: The poll to create.
        /// - Throws: A repository-specific error if creation fails.
    func createPollAndReturnID(_ poll: Poll) async throws -> String
    
    /// Fetches a single poll by its unique identifier.
        ///
        /// Returns `nil` if the poll does not exist.
        /// - Parameter id: The ID of the poll.
        /// - Returns: The matching `Poll` object or `nil`.
        /// - Throws: A repository-specific error if lookup fails.
    func fetchPoll(byID id: String) async throws -> Poll?
}
