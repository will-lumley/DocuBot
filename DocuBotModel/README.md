# DocuBotModel

## What does DocuBotModel do?

DocuBotModel is the data layer of the DocuBot macOS application, providing the core data models and logic for document parsing, semantic search, and embeddings. 
It supports advanced querying and document similarity operations, leveraging the power of the `SimilaritySearchKit` library for machine learning-driven text processing.

## Features

📄 Core Models
- Project: Represents a collection of documents with metadata and state management.
- Document: Encapsulates individual files, including their embeddings, metadata, and content.
- ProjectSettings: Configurable settings for projects, including embedding models and similarity metrics.

🧠 Semantic Search
- Integration with SimilaritySearchKit for embedding generation and similarity scoring:
- Distilbert: Lightweight transformer for efficient embeddings.
- MiniLMAll: Optimised for a wide range of semantic search tasks.
- MiniLMMultiQA: Fine-tuned for multi-turn QA scenarios.

🔍 Document Parsing and Indexing
- Support for multiple documentation formats:
    - Markdown (.md)
    - Rich Text Format (.rtf)
    - Plain Text (.txt)
    - HTML (.html)
    - Automated embedding generation and efficient chunk-based indexing for semantic search.

🛠️ Mock Data
- Provides mock implementations for testing, including Project, Document, and ProjectSettings mock factories.
