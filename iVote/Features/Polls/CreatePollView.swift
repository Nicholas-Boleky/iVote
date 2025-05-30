//
//  CreatePollView.swift
//  iVote
//
//  Created by Nick on 5/23/25.
//

import SwiftUI

struct CreatePollView<ViewModel: CreatePollViewModeling>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Question")) {
                TextField("Enter the question for your Poll", text: $viewModel.question)
            }
            
            Section(header: Text("Poll Type")) {
                Picker("Poll Type", selection: $viewModel.type) {
                    Text("Multiple Choice").tag(PollType.multipleChoice)
                    Text("Freeform").tag(PollType.freeform)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            if viewModel.type == .multipleChoice {
                Section(header: Text("Options")) {
                    ForEach($viewModel.options.indices, id: \.self) { index in
                        TextField("Option \(index + 1)", text: $viewModel.options[index])
                    }
                    Button("Add Option") {
                        viewModel.options.append("")
                    }
                    .disabled(viewModel.options.count >= 10)
                }
            }
            
            Section(header: Text("Expiration")) {
                DatePicker("Expires At", selection: $viewModel.expiresAt, displayedComponents: [.date, .hourAndMinute])
            }
            
            Section {
                
                if viewModel.isSubmitting {
                    HStack {
                        Spacer()
                        ProgressView("Creating Poll...")
                        Spacer()
                    }
                } else {
                    Button("Create Poll") {
                        Task { await viewModel.submit() }
                    }
                    .disabled(!viewModel.canSubmit)
                }
            }
            
            if let status = viewModel.statusMessage {
                Section {
                    Text(status).foregroundStyle(.blue)
                }
            }
            
            // NavigationLink triggered by poll creation
            if let id = viewModel.createdPollID {
                NavigationLink(
                    tag: id,
                    selection: Binding<String?>(
                        get: { viewModel.createdPollID },
                        set: { viewModel.createdPollID = $0 }
                    ),
                    destination: {
                        SharePollView(pollID: id)
                    },
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
            }

        }
        .navigationDestination(for: String.self) { pollID in
            SharePollView(pollID: pollID)
        }
        .navigationTitle("Create Poll")
    }
}
