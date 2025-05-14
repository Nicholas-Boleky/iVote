//
//  Poll.swift
//  iVote
//
//  Created by Nick on 5/14/25.
//

import Foundation

struct Poll: Identifiable, Equatable {
    var id: String
    var question: String
    var options: [PollOption]
    let createdAt: Date
    let expiresAt: Date?
}

struct PollOption: Identifiable, Equatable {
    let id: String
    let text: String
}
