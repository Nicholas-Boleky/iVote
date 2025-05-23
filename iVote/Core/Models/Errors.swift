//
//  PollRepositoryError.swift
//  iVote
//
//  Created by Nick on 5/15/25.
//

import Foundation

enum PollRepositoryError: Error {
    case invalidRecord
}

enum UserSessionError: Error {
    case signOutNotSupported
}
