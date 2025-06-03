//
//  CreatePollViewModel.swift
//  iVote
//
//  Created by Nick on 5/23/25.
//

import Foundation

//@MainActor
//protocol CreatePollViewModeling: ObservableObject {
//    var question: String { get set }
//    var type: PollType { get set }
//    var options: [String] { get set }
//    var expiresAt: Date { get set }
//    var statusMessage: String? { get }
//    var createdPollID: String? { get set }
//    var isSubmitting: Bool { get }
//    
//    var canSubmit: Bool { get }
//    
//    func submit() async
//    
//}

@MainActor
final class CreatePollViewModel: ObservableObject {
    @Published var question: String = ""
    @Published var type: PollType = .multipleChoice
    @Published var options: [String] = []
    //TODO: Revisit this default value
    @Published var expiresAt: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @Published var createdPollID: String? = nil
    @Published var isSubmitting: Bool = false
    @Published var didCreatePollWithID: String?
    var statusMessage: String?
    
    private let pollRepository: PollRepository
    
    init(pollRepository: PollRepository) {
        self.pollRepository = pollRepository
    }
    
    var canSubmit: Bool {
        !question.isEmpty && (type == .freeform || options.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.count >= 2)
    }
    
    func submit() async {
        guard canSubmit else {
            statusMessage = "Please fill out all required fields."
            return
        }
        
        isSubmitting = true
        defer { isSubmitting = false }
        
        let validOptions = options
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { PollOption(id: UUID().uuidString, text: $0) }
        
        let poll = Poll(
            id: UUID().uuidString,
            type: type,
            question: question,
            options: validOptions,
            createdAt: Date(),
            expiresAt: expiresAt
        )
        
        do {
            let pollID = try await pollRepository.createPollAndReturnID(poll)
            statusMessage = "Poll created successfully!"
            createdPollID = pollID
            didCreatePollWithID = pollID
        } catch {
            statusMessage = "Error creating Poll: \(error.localizedDescription)"
        }
    }
}

