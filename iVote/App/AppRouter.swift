//
//  AppRouter.swift
//  iVote
//
//  Created by Nick on 5/13/25.
//

import Foundation

final class AppRouter: ObservableObject { //final to prevent subclassing, better performance
    @Published var currentScreen: AppScreen = .pollList
}

enum AppScreen {
    case pollList
    case pollCreation
    case lobby(pollID: String)
    case vote(pollID: String)
    case results(pollID: String)
}
