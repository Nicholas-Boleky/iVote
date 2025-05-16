//
//  AppContainer.swift
//  iVote
//
//  Created by Nick on 5/15/25.
//

import Foundation
/// A central container for dependency injection. Provides access to repositories and shared services.
@MainActor
final class AppContainer: ObservableObject {
    
    // MARK: - Repository Instances
    
    let pollRepository: PollRepository
    let voteRepository: VoteRepository
    let userSessionRepository: UserSessionRepository

    // MARK: - Init
    
    init(
        pollRepository: PollRepository = CloudKitPollRepository(),
        voteRepository: VoteRepository = CloudKitVoteRepository(),
        userSessionRepository: UserSessionRepository = CloudKitUserSessionRepository()
    ) {
        self.pollRepository = pollRepository
        self.voteRepository = voteRepository
        self.userSessionRepository = userSessionRepository
    }
}
