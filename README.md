# DocuBot - Your Private AI Documentation Assistant

![Cover](https://github.com/user-attachments/assets/bea63f82-3041-4453-b706-2021de41f30d)

![Unit Tests](https://github.com/will-lumley/DocuBot/actions/workflows/UnitTests.yml/badge.svg?branch=main)
![UI Tests](https://github.com/will-lumley/DocuBot/actions/workflows/UITests.yml/badge.svg?branch=main)

DocuBot is a native macOS app powered by an open-source LLM, designed to intelligently answer your code documentation queries by parsing and understanding various documentation files.
DocuBot indexes your project’s documentation files, “studies” them, and provides you with accurate answers to any questions you have about your project.

•	Privacy-First Design: All processing happens locally, with no network calls or data collection.
•	Customizable AI Models: Choose or import AI models to match your Mac’s capabilities and project needs.
•	Open Source: Fully transparent codebase that you can inspect, modify, and trust.
 
### How it Works

DocuBot is designed to help developers quickly navigate and understand project documentation through efficient, on-device AI processing. Here’s a look under the hood at how DocuBot works to provide answers to your documentation questions while ensuring privacy and data security.

When a project is loaded into DocuBot, it scans the specified directory, iterating over each documentation file in supported formats (e.g., .md, .txt). For each valid file, DocuBot reads the content, generating a unique checksum to track changes over time. To optimize querying, DocuBot breaks each document’s content into several chunks, making long documents manageable and ensuring relevant sections are easy to retrieve. Each chunk is then processed to create an array of floating-point numbers, known as an “embedding.” These embeddings are numerical representations of each chunk’s semantic meaning, allowing DocuBot to understand and compare chunks based on their content.

DocuBot stores these embeddings in a similarity index configured with user-selected metrics (such as Cosine similarity), enabling efficient searches. When you ask a question, DocuBot leverages this index to identify the most relevant chunks across all documents, measuring how closely each chunk aligns with your query. If “Strict Mode” is enabled, DocuBot will pull direct excerpts from the documentation, presenting them as-is to provide precise, source-based responses. Otherwise, it uses an on-device language model to generate a polished answer based on the relevant chunks.

With each query, DocuBot performs all computations locally on your Mac, ensuring your data remains private. As an open-source tool, DocuBot’s code is fully transparent, allowing users to verify its privacy-focused design. Periodically, DocuBot checks if any documentation has changed by comparing checksums, prompting you to re-sync when necessary to keep the information up-to-date.

This combination of local processing, privacy protection, and flexible model configuration makes DocuBot a powerful and secure documentation assistant, perfectly tailored to developers’ needs.

### Project Structure

This project is structured with a modular design, with different responsibilities and concerns handled by separate Swift Package Manager (SPM) modules. The project is structured with the following layers/modules:

- [DocuBotUI](https://github.com/will-lumley/DocuBot/tree/main/DocuBotUI): Contains SwiftUI views used to create the user interface.
- [DocuBotViewModel](https://github.com/will-lumley/DocuBot/tree/main/CraneViewModel): Manages the data and operations needed by the user interface.
- [DocuBotService](https://github.com/will-lumley/DocuBot/tree/main/DocuBotService): Handles interactions with external services such as API communication, analytics, etc.
- [DocuBotModel](https://github.com/will-lumley/DocuBot/tree/main/DocuBotModel): Contains the business logic and data models used in the app.
- [DocuBotToolbox](https://github.com/will-lumley/DocuBot/tree/main/DocuBotToolbox): A utility module containing basic data types and helper functions used throughout the app.
  
### Prerequisites

- A Mac running macOS Sequoia
- Xcode 16.0
- SwiftGen
- SwiftLint

### Installation

- Clone the repo: `git clone git@github.com:will-lumley/DocuBot.git`
- Open `DocuBot.xcworkspace` in Xcode
- Build and run the project on the desired device or simulator

## Testing
- Ensure that each module of the application has >80% unit test coverage

## Third Party Infrastructure
- N/A as DocuBot operates entirely offline, outside of downloading a default model.

## Keep in Mind
- Do not reference strings directly, but rather through the swift-gen (sourced from Localizable.strings file)
- Do not reference images directly, but rather through the swift-gen

## Acknowledgments
- https://github.com/ZachNagengast/similarity-search-kit.git
- https://github.com/ShenghaiWang/SwiftLlama
- https://github.com/ggerganov/llama.cpp.git
- https://github.com/SFSafeSymbols/SFSafeSymbols
- https://github.com/SwiftfulThinking/SwiftfulLoadingIndicators
- https://github.com/groue/GRDB.swift
- https://github.com/unsignedapps/Vexil
- https://github.com/gonzalezreal/swift-markdown-ui
- https://github.com/realm/SwiftLint
- https://github.com/SwiftGen/SwiftGenPlugin
