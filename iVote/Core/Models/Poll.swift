//
//  Poll.swift
//  iVote
//
//  Created by Nick on 5/14/25.
//

import Foundation

struct Poll: Identifiable, Equatable {
    let id: String
    let type: PollType
    let question: String
    let options: [PollOption]
    let createdAt: Date
    let expiresAt: Date?
}

struct PollOption: Identifiable, Equatable {
    let id: String
    let text: String
}

enum PollType: String, Codable {
    case multipleChoice
    case freeform
}
