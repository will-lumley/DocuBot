# DocuBot - macOS

![Header](https://github.com/user-attachments/assets/3b7fbde2-cdc3-4aff-941e-5f82b99f1fa1)

![Unit Tests](https://github.com/will-lumley/DocuBot/actions/workflows/UnitTests.yml/badge.svg?branch=main)
![UI Tests](https://github.com/will-lumley/DocuBot/actions/workflows/UITests.yml/badge.svg?branch=main)

DocuBot is a macOS app powered by an open-source LLM, designed to intelligently answer your code documentation queries by parsing and understanding various documentation files.

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
