//
//  UserSessionRepository.swift
//  iVote
//
//  Created by Nick on 5/14/25.
//

import Foundation

/// A repository for accessing and managing the current user session.
///
/// Abstracts user identity handling for backends like CloudKit or Firebase.
protocol UserSessionRepository {

    /// Returns the current authenticated user.
    ///
    /// Implementations may fetch this from iCloud, Firebase, or a local store.
    /// - Returns: A `User` object representing the current session.
    /// - Throws: An error if the user could not be determined or authentication failed.
    func getCurrentUser() async throws -> User

    /// Signs the user out, if supported by the backend.
    ///
    /// - Throws: An error if sign-out fails or is unsupported.
    func signOut() async throws
}
