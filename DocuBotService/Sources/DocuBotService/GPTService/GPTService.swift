//
//  GPTService.swift
//
//
//  Created by William Lumley on 9/9/2024.
//

import Combine
import DocuBotModel
import Foundation

/// A protocol defining the requirements for a conversational AI service.
///
/// The `GPTService` protocol provides methods for priming a model, responding to user queries, and managing
/// the lifecycle of AI interactions.
public protocol GPTService: Service {

    /// A closure type used to handle real-time updates to the output during a response.
    ///
    /// The closure is called on the main actor and provides the incremental text updates as they are generated.
    typealias OutputUpdated = @MainActor (_ delta: String) -> Void

    /// Primes the service with a specific language model and project settings.
    ///
    /// This method prepares the conversational AI service to respond to queries based on the provided
    /// model and settings.
    ///
    /// - Parameters:
    ///   - model: The `LLMModel` to use for generating responses.
    ///   - settings: The `ProjectSettings` that define parameters such as embedding
    ///   model and similarity metrics.
    /// - Throws: A `GPTError` if the service fails to prime.
    func prime(
        with model: LLMModel,
        with settings: ProjectSettings
    ) throws(GPTError)

    /// Generates a response to a query, optionally providing real-time updates.
    ///
    /// This method processes the user's query and generates a response based on the primed model and settings.
    ///
    /// - Parameters:
    ///   - query: The user's input query.
    ///   - systemMessage: A system-level prompt that provides context or instructions for the AI's response.
    ///   - onUpdate: An optional closure that provides incremental updates to the response
    ///   text as it is generated.
    /// - Returns: The full response string once generation is complete.
    /// - Throws: An error if the response generation fails.
    func respond(
        to query: String,
        onUpdate: OutputUpdated?
    ) async throws -> String

    /// Stops any ongoing response generation.
    ///
    /// This method is used to interrupt the AI's response generation process.
    func stop()

}
