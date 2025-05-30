//
//  AppRouter.swift
//  iVote
//
//  Created by Nick on 5/13/25.
//

import Foundation

final class AppRouter: ObservableObject, Observable { //final to prevent subclassing, better performance
    @Published var currentScreen: AppScreen = .landingPage
    
    func navigate(to screen: AppScreen) {
        currentScreen = screen
    }
}

enum AppScreen {
    case pollList
    case pollCreation
    case lobby(pollID: String)
    case vote(pollID: String)
    case results(pollID: String)
    case wireframe
    case landingPage
    case sharePoll(pollID: String)
}
