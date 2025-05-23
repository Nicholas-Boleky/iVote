//
//  CloudKitPollRepository.swift
//  iVote
//
//  Created by Nick on 5/15/25.
//

import Foundation
import CloudKit

/// A CloudKit-based implementation of `PollRepository` using the public iCloud database.
final class CloudKitPollRepository: PollRepository {
    private let database: CKDatabase = CKContainer(identifier: "iCloud.iVote").publicCloudDatabase
    
    // MARK: - Fetch Polls
    
    func fetchPolls() async throws -> [Poll] {
        let predicate = NSPredicate(value: true) // Fetch all polls
        let query = CKQuery(recordType: "Poll", predicate: predicate)
        
        let (matchedResults, _) = try await database.records(matching: query)
        
        return try matchedResults.compactMap { (_, result) in
            let record = try result.get()
            return try parsePoll(from: record)
        }
    }

    // MARK: - Create Poll
    
    func createPoll(_ poll: Poll) async throws {
        let record = CKRecord(recordType: "Poll")
        record["type"] = poll.type.rawValue
        record["question"] = poll.question
        record["options"] = poll.options.map { $0.text } as NSArray
        record["createdAt"] = poll.createdAt
        if let expiresAt = poll.expiresAt {
            record["expiresAt"] = expiresAt
        }
        
        try await database.save(record)
    }
    
    // MARK: - Fetch Poll by ID
    
    func fetchPoll(byID id: String) async throws -> Poll? {
        let recordID = CKRecord.ID(recordName: id)
        
        do {
            let record = try await database.record(for: recordID)
            return try parsePoll(from: record)
        } catch {
            if (error as? CKError)?.code == .unknownItem {
                return nil
            } else {
                throw error
            }
        }
    }
    
    // MARK: - Helper
    
    /// Parses a `CKRecord` into a `Poll` domain model.
    private func parsePoll(from record: CKRecord) throws -> Poll {
        guard
            let question = record["question"] as? String,
            let optionsArray = record["options"] as? [String],
            let createdAt = record["createdAt"] as? Date,
            let typeString = record["type"] as? String,
            let type = PollType(rawValue: typeString)
        else {
            throw PollRepositoryError.invalidRecord
        }

        let options: [PollOption] = optionsArray.enumerated().map { index, text in
            PollOption(id: "\(record.recordID.recordName)_\(index)", text: text)
        }

        let expiresAt = record["expiresAt"] as? Date

        return Poll(
            id: record.recordID.recordName,
            type: type,
            question: question,
            options: options,
            createdAt: createdAt,
            expiresAt: expiresAt
        )
    }
}
