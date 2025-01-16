//
//  ChatViewModel.swift
//
//
//  Created by William Lumley on 14/8/2024.
//

import Combine
import DocuBotModel
import DocuBotService
import DocuBotToolbox
import Foundation
import NaturalLanguage

public class ChatViewModel: DocuBotViewModel, Identifiable {

    // MARK: - Types

    public enum LoadingState: Hashable {
        case loading
        case partial(content: String)
        case none
    }

    // MARK: - Properties

    @Published public var chatText = ""
    @Published public var messages: [MessageCellViewModel]?

    @Published public var loadingState = LoadingState.none

    public var id: Int64 {
        self.chat.id ?? -1
    }

    private var chat: Chat

    // MARK: - Lifecycle

    public init(chat: Chat, serviceContainer: ServiceContainer) {
        self.chat = chat
        super.init(serviceContainer: serviceContainer)
    }

    public override func configureBindings() {
        super.configureBindings()

        // Connect our MessageCellViewModels to our DB layer
        persistenceService.getMessages(for: self.chat)
            .map { $0.map { MessageCellViewModel(message: $0) } }
            .replaceError(with: [])
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)

        // Connect our Messages to our Chat instance
        persistenceService.getMessages(for: self.chat)
            .replaceError(with: [])
            .sink { self.chat.load(messages: $0) }
            .store(in: &cancellables)
    }

}

// MARK: - Public

public extension ChatViewModel {

    var emptyMessageConfiguration: EmptyListConfiguration {
        .init(
            title: L10n.Project.EmptyChat.title,
            subtitle: L10n.Project.EmptyChat.subtitle,
            icon: .message
        )
    }

    func enterSelected() {
        guard self.canSendNewMessage else {
            return
        }

        // Cache our query
        let query = self.chatText

        // Create our message from our user
        let message = Message(
            content: query,
            author: .user,
            chatID: self.id,
            createdAt: .now
        )
        self.insert(message: message)

        // Clear out our ChatText
        // Update our state to loading
        self.chatText = ""
        self.loadingState = .loading

        Task {
            do {
                let project = try await self.getProject(fetchDocuments: true)
                let results = try await project.fetchRelevantDocumentation(for: query)

                for result in results {
                    print("Result: \(result)\n\n\n")
                }

                // Pull out the IDs of our documents
                let ids = results.compactMap { result -> Int64? in
                    guard let idStr = result.metadata["id"] else {
                        return nil
                    }
                    return Int64(idStr)
                }
                let documents = try await persistenceService.getDocuments(ids: ids)
                
            } catch {
                fatalError(error.localizedDescription)
            }
        }

        // Ask the GPT our question
        Task {
            // await self.queryGPT(with: foo)
        }
    }

}

// MARK: - Private

private extension ChatViewModel {

    var canSendNewMessage: Bool {
        guard self.chatText.isEmpty == false else {
            return false
        }

        guard self.loadingState == .none else {
            return false
        }

        return true
    }

    var currentPartialMessage: String? {
        switch self.loadingState {
        case .partial(let content):
            return content
        default:
            return nil
        }
    }

    func insert(message: Message) {
        Task {
            do {
                print("Inserted Message: \(message.content)")
                print("")
                // Insert the message into the database
                _ = try await persistenceService.insert(message: message)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    func getProject(fetchDocuments: Bool) async throws -> Project {
        var project = try await persistenceService.getProject(id: chat.projectID)

        if fetchDocuments == false {
            return project
        }

        let documents = try await persistenceService.getDocuments(for: project)
        project.load(documents: documents)

        return project
    }

    func queryGPT(with message: String) async {
        do {
            // Pull out our project
            let project = try await persistenceService.getProject(id: chat.projectID)

            // Pass on our input to our GPT Service
            await self.gptService.respond(
                to: message,
                from: self.chat,
                from: project,
                onUpdate: { newPart in
                    // Add the new bit of string to our partialMessage
                    let currentPartial = self.currentPartialMessage ?? ""
                    let newPartial = currentPartial + newPart
                    DispatchQueue.main.async {
                        self.loadingState = .partial(content: newPartial)
                    }
                },
                onComplete: { response in
                    print("ChatID: \(self.id)")
                    DispatchQueue.main.async { self.loadingState = .none }

                    // Insert this message into our database
                    let message = Message(
                        content: response,
                        author: .docubot,
                        chatID: self.id,
                        createdAt: .now
                    )
                    self.insert(message: message)
                }
            )

        } catch {
            fatalError(error.localizedDescription)
        }
    }

}

// MARK: - Preview

public extension ChatViewModel {

    static var mock: ChatViewModel {
        .init(
            chat: .init(
                id: 1,
                name: "Chat Name",
                nameType: .userSet,
                projectID: 1,
                createdAt: .now
            ),
            serviceContainer: .mock
        )
    }

}
