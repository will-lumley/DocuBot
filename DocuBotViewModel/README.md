# DocuBotViewModel

## What does DocuBotViewModel do?

The DocuBotViewModel module serves as the logic and coordination layer for the DocuBot macOS application.
It bridges the gap between the application’s data (models and services) and the user interface, ensuring a responsive and cohesive experience.

## Features

🪄 Core Responsibilities
- Coordinates between models, services, and the UI.
- Publishes updates and state changes to the UI using Combine.
- Handles user interactions, state management, and data flow.

🔄 Reactive Architecture
- Utilises Combine for state management and event publishing.
- Utilises async/await to handle conucrrency
- Ensures real-time UI updates based on changes in the persistence layer or other services.
