//
//  Vote.swift
//  iVote
//
//  Created by Nick on 5/14/25.
//

import Foundation

struct Vote: Identifiable, Equatable {
    let id: String
    let pollID: String
    let optionID: String
    let userID: String
    let timestamp: Date
}
