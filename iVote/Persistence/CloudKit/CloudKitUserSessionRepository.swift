//
//  CloudKitUserSessionRepository.swift
//  iVote
//
//  Created by Nick on 5/15/25.
//

import CloudKit
import Foundation

/// A CloudKit-based implementation of `UserSessionRepository` that uses the iCloud account on the device.
final class CloudKitUserSessionRepository: UserSessionRepository {
    
    /// The cached user ID to avoid repeated lookups
    private var cachedUser: User?
    
    func getCurrentUser() async throws -> User {
        if let cachedUser = cachedUser {
            return cachedUser
        }

        let recordID = try await CKContainer.default().userRecordID()
        let recordName = recordID.recordName

        let user = User(id: recordName, displayName: nil)
        cachedUser = user
        return user
    }
}
