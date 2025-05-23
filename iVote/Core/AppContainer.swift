//
//  AppContainer.swift
//  iVote
//
//  Created by Nick on 5/15/25.
//

import Foundation
/// A central container for dependency injection.
@MainActor
final class AppContainer: ObservableObject {
        
    let pollRepository: PollRepository
    let voteRepository: VoteRepository
    let userSessionRepository: UserSessionRepository
    
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
