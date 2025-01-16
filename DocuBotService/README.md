# DocuBotService

## What does DocuBotService do?

DocuBotService provides the backbone for DocuBot, managing core application services such as database operations, AI model interactions, logging, and feature flagging. This module is designed to support seamless integration between the app’s business logic and its foundational components.

## Features

🗂️ Service Management
- Provides a ServiceContainer to manage and register application services, ensuring a modular and extensible architecture.

📊 Database Integration
- Utilises GRDB for robust SQLite database management.
- Includes support for migrations and advanced database queries.

🤖 AI Model Interaction
- Integrates with llama.cpp for managing and querying large language models (LLMs).
- Provides abstractions to prime models, handle queries, and respond dynamically.

🛠️ Logging and Debugging
- Offers a flexible logging service to manage debug output, including a PrintLogService for simple logging to the console and an EmptyLogService for silent operations.

🚩 Feature Flag Management
- Seamlessly integrates with DocuBotToolbox and Vexil for feature flagging, enabling controlled experimentation and rollout of features.

## Dependencies

This module relies on the following libraries:
- SwiftGen: Type-safe access to assets.
- Vexil: Feature flag management.
