//
//  CreatePollView.swift
//  iVote
//
//  Created by Nick on 5/23/25.
//

import SwiftUI

//struct CreatePollView<ViewModel: CreatePollViewModeling>: View {
struct CreatePollView: View {
    @EnvironmentObject var appRouter: AppRouter
    @ObservedObject var viewModel: CreatePollViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button {
                appRouter.navigate(to: .landingPage)
            } label: {
                Label("Home", systemImage: "chevron.left")
            }
            .padding()
            
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
            }
            .onChange(of: viewModel.didCreatePollWithID) { oldID, newID in
                if let id = newID {
                    appRouter.navigate(to: .sharePoll(pollID: id))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Create Poll")
        }
    }
}
