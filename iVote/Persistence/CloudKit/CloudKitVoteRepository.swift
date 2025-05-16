//
//  CloudKitVoteRepository.swift
//  iVote
//
//  Created by Nick on 5/15/25.
//

import CloudKit
import Foundation

/// A CloudKit-based implementation of `VoteRepository`, using the public database.
final class CloudKitVoteRepository: VoteRepository {
    private let database: CKDatabase = CKContainer.default().publicCloudDatabase

    // MARK: - Submit Vote

    func submitVote(_ vote: Vote) async throws {
        let record = CKRecord(recordType: "Vote")
        record["pollID"] = vote.pollID
        record["optionID"] = vote.optionID
        record["userID"] = vote.userID
        record["timestamp"] = vote.timestamp

        try await database.save(record)
    }

    // MARK: - Vote Count by Poll

    func getVoteCounts(for pollID: String) async throws -> [String: Int] {
        let predicate = NSPredicate(format: "pollID == %@", pollID)
        let query = CKQuery(recordType: "Vote", predicate: predicate)

        let (matchedResults, _) = try await database.records(matching: query)

        let optionVotes = try matchedResults.compactMap { (_, result) in
            try result.get()["optionID"] as? String
        }

        return Dictionary(grouping: optionVotes, by: { $0 }).mapValues { $0.count }
    }

    // MARK: - Vote Observer

    func observeVotes(for pollID: String) -> AsyncStream<Vote> {
        AsyncStream { continuation in
            let subscription = CKQuerySubscription(
                recordType: "Vote",
                predicate: NSPredicate(format: "pollID == %@", pollID),
                subscriptionID: UUID().uuidString,
                options: [.firesOnRecordCreation]
            )

            let notificationInfo = CKSubscription.NotificationInfo()
            notificationInfo.shouldSendContentAvailable = true
            subscription.notificationInfo = notificationInfo

            // Add the subscription
            Task {
                do {
                    try await database.save(subscription)
                } catch {
                    print("Subscription failed: \(error)")
                }
            }

        //TODO: placeholder for upgrade with CloudKit push

            // To stop the stream
            continuation.onTermination = { @Sendable _ in
                //TODO: remove subscription or cleanup
            }
        }
    }
}
