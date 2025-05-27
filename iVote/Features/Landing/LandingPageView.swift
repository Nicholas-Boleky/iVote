//
//  LandingPageView.swift
//  iVote
//
//  Created by Nick on 5/23/25.
//

import SwiftUI

struct LandingPageView: View {
    @EnvironmentObject var container: AppContainer
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Text("Welcome to iVote")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 20) {
                NavigationLink {
                    CreatePollView(
                        viewModel: CreatePollViewModel(pollRepository: container.pollRepository)
                    )
                } label: {
                    Text("Create Poll")
                }
                .buttonStyle(LandingButtonStyle())
                
                Button("Vote in Open Poll") {
                    //TODO: Hook into appRouter
                }
                .buttonStyle(LandingButtonStyle())
            }
            
            Spacer()
        }
        .padding()
    }
}

struct LandingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(configuration.isPressed ? 0.6 : 0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
            .font(.headline)
    }
}

#Preview {
    LandingPageView()
}
